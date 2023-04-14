#pragma once

#include <kodi/addon-instance/Game.h>

class ATTR_DLL_LOCAL CGameRetroArch
  : public kodi::addon::CAddonBase,
    public kodi::addon::CInstanceGame
{
public:
  CGameRetroArch();
  ~CGameRetroArch() override;

  ADDON_STATUS Create() override;
  ADDON_STATUS SetSetting(const std::string& settingName, const kodi::addon::CSettingValue& settingValue) override;

  GAME_ERROR LoadGame(const std::string& url) override;
  GAME_ERROR LoadGameSpecial(SPECIAL_GAME_TYPE type, const std::vector<std::string>& urls) override;
  GAME_ERROR LoadStandalone() override;
  GAME_ERROR UnloadGame() override;
  GAME_ERROR GetGameTiming(game_system_timing& timing_info) override;
  GAME_REGION GetRegion() override;
  bool RequiresGameLoop() override;

  game_input_topology* GetTopology() override;
  void FreeTopology(game_input_topology* topology) override;
  void SetControllerLayouts(const std::vector<kodi::addon::GameControllerLayout>& controllers) override;
  bool EnableKeyboard(bool enable, const std::string& controller_id) override;
  bool EnableMouse(bool enable, const std::string& controller_id) override;
  bool ConnectController(bool connect, const std::string& port_address, const std::string& controller_id) override;
  bool InputEvent(const game_input_event& event) override;

  size_t SerializeSize() override;

private:
  GAME_ERROR LaunchRetroArch(const std::string& core);
};
