module EBJB_Bestiary
  # Build filename
  FINAL   = "build/EBJB_Bestiary.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/Bestiary_Config.rb",
    "src/Game Objects/Game_Battler.rb",
    "src/Game Objects/Game_Enemy.rb",
    "src/Game Objects/Game_Party.rb",
    "src/RPG Objects/RPG_Enemy Addon.rb",
    "src/Scenes/Scene_Battle.rb",
    "src/Scenes/Scene_Bestiary.rb",
    "src/Scenes/Scene_Menu.rb",
    "src/Scenes/Sub_Scene_Scan.rb",
    "src/User Interface/Font.rb",
    "src/User Interface/Color.rb",
    "src/User Interface/Vocab.rb",
    "src/Windows/Window_Bestiary_Info.rb",
    "src/Windows/Window_Enemy_Drops.rb",
    "src/Windows/Window_Enemy_Image.rb",
    "src/Windows/Window_Enemy_Name.rb",
    "src/Windows/Window_Enemy_Skills.rb",
    "src/Windows/Window_Enemy_Status.rb",
    "src/User Controls/UCDropItem.rb",
    "src/User Controls/UCEnemySpoil.rb",
    "src/User Controls/UCEnemyStatus.rb",
    "src/User Controls/UCSkill.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_Bestiary::FINAL, "w+")
  EBJB_Bestiary::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
