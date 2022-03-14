extends Node

#LevelInfo
var currentLevel = 1
#Bosts
var JumpPointsGainedPerHealthPointLoss = 25000
var SpeedPointsGainedPerHealthPointLoss = 50
var initialHealthPoints = 120
#movement
var Speed = 10
var JumpSpeed = 500
var gravity = -500
#player stats
var HPTOSCALE = 0.01 # 1 hp equals 0.1 scale
var MaxHealthPoints = 500
#jump limits
var GravityReducer = 2
var JumpMovementReducer = 2
