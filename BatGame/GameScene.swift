import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    
    
    var player: SKSpriteNode!
    var bullets: [SKSpriteNode] = []
    
    var bat: SKSpriteNode!
    var bat_array:[SKSpriteNode] = []
    
    var bat_frames: [SKTexture] = []
    var bat_atlas: SKTextureAtlas!
    
    var GAMEOVER: Bool = false
    
    var redBall: SKShapeNode!
    var ground: SKShapeNode!
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        player = SKSpriteNode(imageNamed: "Aircraft_05")
        player.texture?.filteringMode = .nearest
        player.size = CGSize(width: 80, height: 80)
        player.position = CGPoint(x: frame.midX, y: frame.minY + 60)
        addChild(player)
        
        
        
        bat_atlas = SKTextureAtlas(named: "Bats")
        bat_frames.append(bat_atlas.textureNamed("32x32-bat-sprite_5"))
        bat_frames.append(bat_atlas.textureNamed("32x32-bat-sprite_9"))
        bat_frames.append(bat_atlas.textureNamed("32x32-bat-sprite_13"))
        
        let first_fram_texture = bat_frames[0]
        bat = SKSpriteNode(texture: first_fram_texture)
        bat.position = CGPoint(x: frame.midX, y: frame.maxY + 40)
        bat.size = CGSize(width: 80, height: 80)
        bat.texture?.filteringMode = .nearest
        
        bat.run(SKAction.repeatForever(SKAction.animate(with: bat_frames, timePerFrame: 0.15, resize: false, restore: true)), withKey: "bat_flying")
        bat.run(SKAction.move(to: CGPoint(x: frame.midX, y: frame.minY - 40), duration: 2))
        
        
        addChild(bat)
        
        let wait = SKAction.wait(forDuration: 0.5)
        let spawn   = SKAction.run { self.spawn_bat() }
        let action = SKAction.sequence([wait, spawn])
        let forever = SKAction.repeatForever(action)
        self.run(forever)
        
        
        let ballRadius: CGFloat = 20
        redBall = SKShapeNode(circleOfRadius: ballRadius)
        redBall.fillColor = .red
        redBall.position = CGPoint(x: 280, y: 320)
        redBall.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        
        let blueBall = SKShapeNode(circleOfRadius: ballRadius)
        blueBall.fillColor = .blue
        blueBall.position = CGPoint(x: 300, y: 320)
        blueBall.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        
        var splinePoints = [CGPoint(x: 0, y: 300),
                            CGPoint(x: 100, y: 50),
                            CGPoint(x: 400, y: 110),
                            CGPoint(x: 640, y: 20)]
        ground = SKShapeNode(splinePoints: &splinePoints,
                                 count: splinePoints.count)
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.restitution = 1
        
        redBall.physicsBody?.collisionBitMask = 0b0010
        redBall.physicsBody?.contactTestBitMask = redBall.physicsBody?.contactTestBitMask ?? 0
        
        blueBall.physicsBody?.collisionBitMask = 0b001
        
  
        ground.physicsBody?.categoryBitMask = 0b0010
        ground.physicsBody?.contactTestBitMask = 0b100
        
  
        
        
        addChild(redBall)
        addChild(ground)
        addChild(blueBall)
        
       
    }
    
    override func update(_ currentTime: TimeInterval) {
        if bat_array.isEmpty == false {
            for bat in bat_array{
                if bat.position.y < self.frame.minY{
                    bat.removeFromParent()
                }
            }
        } else {return}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if player.contains(location){
                fire()
                
            }
        }
    }
    
    func fire(){
        
        let bullet = SKSpriteNode(imageNamed: "bullet_2_orange")
        bullet.position = player.position
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        bullet.physicsBody?.collisionBitMask = 0b0001
        bullet.name = "bullet"
    
        bullets.append(bullet)
        
        let fire_action = SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.maxY + 40), duration: 1)
        bullet.run(fire_action)
        addChild(bullet)
        
    }
    

    func spawn_bat(){
        
        
        let a_bat = SKSpriteNode(texture: bat_frames[0])
        a_bat.size = CGSize(width: 80, height: 80)
        let random_xPos = CGFloat.random(in: 40 ..< self.frame.maxX - 40)
        a_bat.position.y = self.frame.maxY + 40
        a_bat.position.x = random_xPos
        a_bat.run(SKAction.repeatForever(SKAction.animate(with: bat_frames, timePerFrame: 0.15, resize: false, restore: true)), withKey: "bat_flying")
        a_bat.run(SKAction.move(to: CGPoint(x: random_xPos, y: frame.minY - 40), duration: 2))
        
        a_bat.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        a_bat.physicsBody?.categoryBitMask = 0b0001
        a_bat.physicsBody?.contactTestBitMask = 0b0001
        
        bat_array.append(a_bat)
        addChild(a_bat)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == redBall {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB == redBall {
            collisionBetween(ball: nodeB, object: nodeA)
        }
        
        for _ in bullets{
            if nodeA.name == "bullet"{
                bat_is_hit(bat: nodeA, bullet: nodeB)
            }else if nodeB.name == "bullet" {
                bat_is_hit(bat: nodeB, bullet: nodeA)
            }
        }
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        
    }
    
    func bat_is_hit(bat: SKNode, bullet: SKNode){
        bat.removeFromParent()
        bullet.removeFromParent()
    }
    
}
