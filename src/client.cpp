#include "client.h"

#include <set>
#include <string>
#include <vector>

#include <kodi/General.h>

#include <interfaces/builtins/Builtins.h>
#include <Util.h>
#include <stdlib.h>

GAME_ERROR CGameRetroArch::LaunchRetroArch(const std::string& core){
  kodi::Log(ADDON_LOG_INFO, "Launching RetroArch");

  //std::string command ("System.Exec(retroarch-ctl,run)");
  //int retval = CBuiltins::GetInstance().Execute(command);

  std::string command = "systemd-run,/storage/.kodi/addons/game.retroarch/bin/retroarch-ctl,run";
  if(core!=""){
    command += "," + core;
  }
  int retval = CUtil::RunCommandLine(command, false);

  //int retval = system("/storage/.kodi/addons/game.retroarch/bin/retroarch-ctl run");

  if (retval){
    kodi::Log(ADDON_LOG_DEBUG, "RetroArch launched");
  } else {
    kodi::Log(ADDON_LOG_ERROR, "Could not launch RetroArch");
  }

  CloseGame();

  return GAME_ERROR_NO_ERROR;
  //return GAME_ERROR_NOT_LOADED;
}

CGameRetroArch::CGameRetroArch()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::CGameRetroArch");
}

CGameRetroArch::~CGameRetroArch()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::~CGameRetroArch");
}

ADDON_STATUS CGameRetroArch::Create()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::Create");
  return ADDON_STATUS_OK;
}

ADDON_STATUS CGameRetroArch::SetSetting(const std::string& settingName, const kodi::addon::CSettingValue& settingValue)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::SetSetting");
  return ADDON_STATUS_OK;
}

GAME_ERROR CGameRetroArch::LoadGame(const std::string& url)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::LoadGame");
  
  return LaunchRetroArch(url);
}

GAME_ERROR CGameRetroArch::LoadGameSpecial(SPECIAL_GAME_TYPE type, const std::vector<std::string>& urls)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::LoadGameSpecial");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::LoadStandalone()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::LoadStandalone");

  return LaunchRetroArch("");
}

GAME_ERROR CGameRetroArch::UnloadGame()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::UnloadGame");
  return GAME_ERROR_NO_ERROR;
}

bool CGameRetroArch::RequiresGameLoop(){
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::RequiresGameLoop");
  return false;
}

GAME_ERROR CGameRetroArch::GetGameTiming(game_system_timing& timing_info)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::GetGameTiming");

  timing_info.fps=60;
  timing_info.sample_rate=48000;

  return GAME_ERROR_NO_ERROR;
  //return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_REGION CGameRetroArch::GetRegion()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::GetRegion");
  return GAME_REGION_NTSC;
}

GAME_ERROR CGameRetroArch::RunFrame()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::RunFrane");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::Reset()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::Reset");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::HwContextReset()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::HwContextReset");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::HwContextDestroy()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::HwContextDestroy");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

bool CGameRetroArch::HasFeature(const std::string& controller_id, const std::string& feature_name)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::HasFeature");
  return false;
}

game_input_topology* CGameRetroArch::GetTopology()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::GetTopology");

/*
  game_input_port* port = new game_input_port;
  //port->type = GAME_PORT_CONTROLLER;
  port->type = GAME_PORT_KEYBOARD;
  port->port_id = "COM1";
  port->force_connected = false;
  port->accepted_devices = nullptr;
  port->device_count = 0;

  game_input_topology* t = new game_input_topology;
  t->ports=port;
  t->port_count=1;
  t->player_limit=1;
  return t;
*/

  return nullptr;
}

void CGameRetroArch::FreeTopology(game_input_topology* topology)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::FreeTopology");
  /*
  delete[] topology->ports->accepted_devices;
  delete[] topology->ports;
  delete topology;
  */
}

void CGameRetroArch::SetControllerLayouts(const std::vector<kodi::addon::GameControllerLayout>& controllers)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::SetControllerLayouts");
}

bool CGameRetroArch::EnableKeyboard(bool enable, const std::string& controller_id)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::EnableKeyboard");
  return false;
}

bool CGameRetroArch::EnableMouse(bool enable, const std::string& controller_id)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::EnableMouse");
  return false;
}

bool CGameRetroArch::ConnectController(bool connect, const std::string& port_address, const std::string& controller_id)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::ConnectController");
  return false;
}

bool CGameRetroArch::InputEvent(const game_input_event& event)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::InputEvent");
  return false; 
}

size_t CGameRetroArch::SerializeSize()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::SerializeSize");
  return 0;
}

GAME_ERROR CGameRetroArch::Serialize(uint8_t* data, size_t size)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::Serialize");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::Deserialize(const uint8_t* data, size_t size)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::Deserialize");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::CheatReset()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::CheatReset");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::GetMemory(GAME_MEMORY type, uint8_t*& data, size_t& size)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::GetMemory");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::SetCheat(unsigned int index, bool enabled, const std::string& code)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::SetCheat");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::RCGenerateHashFromFile(std::string& hash,
                                                 unsigned int consoleID,
                                                 const std::string& filePath)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::RCGenerateHashFromFile");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::RCGetGameIDUrl(std::string& url, const std::string& hash)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::RCGetGameIDUrl");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::RCGetPatchFileUrl(std::string& url,
                                            const std::string& username,
                                            const std::string& token,
                                            unsigned int gameID)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::RCGetPatchFileUrl");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::RCPostRichPresenceUrl(std::string& url,
                                                std::string& postData,
                                                const std::string& username,
                                                const std::string& token,
                                                unsigned int gameID,
                                                const std::string& richPresence)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::RCPostRichPresenceUrl");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::RCEnableRichPresence(const std::string& script)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::RCEnableRichPresence");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::RCGetRichPresenceEvaluation(std::string& evaluation,
                                                      unsigned int consoleID)
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::RCGetRichPresenceEvaluation(std::string& evaluation,");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

GAME_ERROR CGameRetroArch::RCResetRuntime()
{
  kodi::Log(ADDON_LOG_DEBUG, "CGameRetroArch::RCResetRuntime");
  //return GAME_ERROR_NO_ERROR;
  return GAME_ERROR_NOT_IMPLEMENTED;
}

ADDONCREATOR(CGameRetroArch)
