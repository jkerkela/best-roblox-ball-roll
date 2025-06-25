local PhysicsService = game:GetService("PhysicsService")

PhysicsService:RegisterCollisionGroup("Player")
PhysicsService:RegisterCollisionGroup("Platforms")

PhysicsService:CollisionGroupSetCollidable("Player", "Default", true)
PhysicsService:CollisionGroupSetCollidable("Platforms", "Default", false)
PhysicsService:CollisionGroupSetCollidable("Platforms", "Platforms", false)
PhysicsService:CollisionGroupSetCollidable("Platforms", "Player", true)
