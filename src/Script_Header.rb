################################################################################
#          EBJB Bestiary + Display Scanned Enemy - EBJB_Bestiary      #   VX   #
#                          Last Update: 2012/03/17                    ##########
#                         Creation Date: 2011/06/25                            #
#                          Author : ChaosHades                                 #
#     Source :                                                                 #
#     http://www.google.com                                                    #
#------------------------------------------------------------------------------#
#  Contains custom scripts to add a Bestiary feature to your game.             #
#==============================================================================#
#                         ** Instructions For Usage **                         #
#  There are settings that can be configured in the Bestiary_Config class. For #
#  more info on what and how to adjust these settings, see the documentation   #
#  in the class.                                                               #
#==============================================================================#
#                                ** Examples **                                #
#  See the documentation in each classes.                                      #
#==============================================================================#
#                           ** Installation Notes **                           #
#  Copy this script in the Materials section                                   #
#==============================================================================#
#                             ** Compatibility **                              #
#  Alias: Game_Battler - skill_effect, item_effect                             #
#  Alias: Game_Enemy - initialize, transform, perform_collapse, escape         #
#  Alias: Scene_Menu - create_command_window, update_command_selection         #
#  Alias: Scene_Battle - create_info_viewport, start, terminate,               #
#                        update_target_enemy_selection                         #
################################################################################

$imported = {} if $imported == nil
$imported["EBJB_Bestiary"] = true
