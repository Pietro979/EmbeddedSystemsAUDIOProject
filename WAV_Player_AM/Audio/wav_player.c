/*
 * wav_player.c
 *
 *  Created on: 17 Apr 2020
 *      Author: Mohamed Yaqoob
 */

#include "wav_player.h"
#include "audioI2S.h"
#include "fatfs.h"
#include "arm_math.h"

#define FILTER_SAMPLES 4096
#define BLOCK_SIZE     100
#define NUM_TAPS 1
//WAV File System variables
static FIL wavFile;

//WAV Audio Buffer
static uint32_t fileLength;
#define AUDIO_BUFFER_SIZE  4096*1
static uint8_t audioBuffer[AUDIO_BUFFER_SIZE];
static __IO uint32_t audioRemainSize = 0;

//WAV Player
static uint32_t samplingFreq;
static UINT playerReadBytes = 0;
static bool isFinished=0;
//WAV Player process states
typedef enum
{
  PLAYER_CONTROL_Idle=0,
  PLAYER_CONTROL_HalfBuffer,
  PLAYER_CONTROL_FullBuffer,
  PLAYER_CONTROL_EndOfFile,
}PLAYER_CONTROL_e;
static volatile PLAYER_CONTROL_e playerControlSM = PLAYER_CONTROL_Idle;

static signed int firInput[FILTER_SAMPLES];
static signed int firOutput[FILTER_SAMPLES];
static signed int firState[NUM_TAPS + BLOCK_SIZE -1];
const double firCoeffs[51] = {
		0.0026527,0.00044098,0.00023411,0.0035268,0.0083258,0.0093808,0.004099,-0.001319,0.0038038,0.02015,0.031623,0.021405,-0.0027628,-0.0086009,0.024022,0.068304,0.069045,0.0093564,-0.049304,-0.019233,0.1042,0.1964,0.098338,-0.21817,-0.58207,1.4123,-0.58207,-0.21817,0.098338,0.1964,0.1042,-0.019233,-0.049304,0.0093564,0.069045,0.068304,0.024022,-0.0086009,-0.0027628,0.021405,0.031623,0.02015,0.0038038,-0.001319,0.004099,0.0093808,0.0083258,0.0035268,0.00023411,0.00044098,0.0026527
			};
void util_calculate_filter(uint16_t *buffer, uint32_t len)
{
    uint16_t i;

    // Create filter instance
    arm_fir_instance_q31 instance;

    // Ensure that the buffer length isn't longer than the sample size
    if (len > FILTER_SAMPLES)
        len = FILTER_SAMPLES;

   for (i = 0; i < len ; i++)
    {
        firInput[i] = (int)buffer[i];
    }

    // Call Initialization function for the filter
    arm_fir_init_q31(&instance, NUM_TAPS, &firCoeffs, &firState, BLOCK_SIZE);

    // Call the FIR process function, num of blocks to process = (FILTER_SAMPLES / BLOCK_SIZE)
    for (i = 0; i < (FILTER_SAMPLES / BLOCK_SIZE); i++) //
    {
        // BLOCK_SIZE = samples to process per call
        //arm_fir_q31(&instance, &firInput[i * BLOCK_SIZE], &firOutput[i * BLOCK_SIZE], BLOCK_SIZE);
        arm_fir_q31(&instance, &firInput[i * BLOCK_SIZE], &firOutput[i * BLOCK_SIZE], BLOCK_SIZE);
    }


    // Convert output back to uint16 for plotting
    for (i = 0; i < (len); i++)
    {
        buffer[i] = (uint16_t)(firOutput[i] - 63500);
    }

}



static void wavPlayer_reset(void)
{
  audioRemainSize = 0;
  playerReadBytes = 0;
}

/**
 * @brief Select WAV file to play
 * @retval returns true when file is found in USB Drive
 */
bool wavPlayer_fileSelect(const char* filePath)
{
  WAV_HeaderTypeDef wavHeader;
  UINT readBytes = 0;
  //Open WAV file
  if(f_open(&wavFile, filePath, FA_READ) != FR_OK)
  {
    return false;
  }
  //Read WAV file Header
  f_read(&wavFile, &wavHeader, sizeof(wavHeader), &readBytes);
  //Get audio data size
  fileLength = wavHeader.FileSize;
  //Play the WAV file with frequency specified in header
  samplingFreq = wavHeader.SampleRate;
  return true;
}

/**
 * @brief WAV File Play
 */
void wavPlayer_play(void)
{
  isFinished = false;
  //Initialise I2S Audio Sampling settings
  audioI2S_init(samplingFreq);
  //Read Audio data from USB Disk
  f_lseek(&wavFile, 0);
  f_read (&wavFile, &audioBuffer[0], AUDIO_BUFFER_SIZE, &playerReadBytes);
  audioRemainSize = fileLength - playerReadBytes;
  //Start playing the WAV

  util_calculate_filter((uint16_t *)&audioBuffer[0],AUDIO_BUFFER_SIZE);

  audioI2S_play((uint16_t *)&audioBuffer[0], AUDIO_BUFFER_SIZE);
}

/**
 * @brief Process WAV
 */
void wavPlayer_process(void)
{
  switch(playerControlSM)
  {
  case PLAYER_CONTROL_Idle:
    break;

  case PLAYER_CONTROL_HalfBuffer:
    playerReadBytes = 0;
    playerControlSM = PLAYER_CONTROL_Idle;
    f_read (&wavFile, &audioBuffer[0], AUDIO_BUFFER_SIZE/2, &playerReadBytes);

    util_calculate_filter((uint16_t *)&audioBuffer[0],AUDIO_BUFFER_SIZE);

    if(audioRemainSize > (AUDIO_BUFFER_SIZE / 2))
    {
      audioRemainSize -= playerReadBytes;
    }
    else
    {
      audioRemainSize = 0;
      playerControlSM = PLAYER_CONTROL_EndOfFile;
    }
    break;

  case PLAYER_CONTROL_FullBuffer:
    playerReadBytes = 0;
    playerControlSM = PLAYER_CONTROL_Idle;
    f_read (&wavFile, &audioBuffer[AUDIO_BUFFER_SIZE/2], AUDIO_BUFFER_SIZE/2, &playerReadBytes);

    util_calculate_filter((uint16_t *)&audioBuffer[0],AUDIO_BUFFER_SIZE);

    if(audioRemainSize > (AUDIO_BUFFER_SIZE / 2))
    {
      audioRemainSize -= playerReadBytes;
    }
    else
    {
      audioRemainSize = 0;
      playerControlSM = PLAYER_CONTROL_EndOfFile;
    }
    break;

  case PLAYER_CONTROL_EndOfFile:
    f_close(&wavFile);
    wavPlayer_reset();
    isFinished = true;
    playerControlSM = PLAYER_CONTROL_Idle;
    break;
  }
}

/**
 * @brief WAV stop
 */
void wavPlayer_stop(void)
{
  audioI2S_stop();
  isFinished = true;
}

/**
 * @brief WAV pause/resume
 */
void wavPlayer_pause(void)
{
  audioI2S_pause();
}
void wavPlayer_resume(void)
{
  audioI2S_resume();
}

/**
 * @brief isEndofFile reached
 */
bool wavPlayer_isFinished(void)
{
  return isFinished;
}

/**
 * @brief Half/Full transfer Audio callback for buffer management
 */
void audioI2S_halfTransfer_Callback(void)
{
  playerControlSM = PLAYER_CONTROL_HalfBuffer;
}
void audioI2S_fullTransfer_Callback(void)
{
  playerControlSM = PLAYER_CONTROL_FullBuffer;
//  audioI2S_changeBuffer((uint16_t*)&audioBuffer[0], AUDIO_BUFFER_SIZE / 2);
}

