def tick(args)
  # 1. Initialize State
  args.state.bunny_count ||= 10000
  args.state.bunnies ||= []

  # 2. sets console command when sample app initially opens. Sets command to reset game with 100 bunnies. User can change this number by typing in the console "reset_with count: 500" to reset with 500 bunnies, for example.
  if Kernel.global_tick_count == 0
    puts ""
    puts ""
    puts "========================================================="
    puts "* INFO: Sprites, Hashes"
    puts "* INFO: Please specify the number of sprites to render."
    GTK.console.set_command "reset_with count: 100"
  end

  # 3. Update bunny Positions & Handle Bouncing
  args.state.bunnies.each do |bunny|
    # Apply velocity
    bunny.x += bunny.dx
    bunny.y += bunny.dy

    # Bounce off Left (0) or Right (1280 - width)
    if bunny.x <= 0 || bunny.x >= 1260
      bunny.dx *= -1
      # Snap back to edge to prevent getting stuck
      bunny.x = (bunny.x <= 0) ? 0 : 1260
    end

    # Bounce off Bottom (0) or Top (720 - height)
    if bunny.y <= 0 || bunny.y >= 700
      bunny.dy *= -1
      bunny.y = (bunny.y <= 0) ? 0 : 700
    end
  end

  # 4. Rendering
  args.outputs.sprites << args.state.bunnies

  # Labels
  args.outputs.labels << [40, 700, "bunnies: #{args.state.bunny_count}", 255, 255, 255]
  args.outputs.labels << [40, 670, "Press '~' to change args.state.bunny_count", 255, 255, 255]
  fps = args.gtk.current_framerate.round
  args.outputs.labels << [40, 630, "FPS: #{fps}", 255, 255, 255]
end

# resets game, and assigns star count given by user
def reset_with(count: count)
  GTK.reset
  GTK.args.state.bunny_count = count
  GTK.args.state.bunnies = GTK.args.state.bunny_count.map do |i| 
        {
        x: rand(1260),
        y: rand(700),
        w: 20,
        h: 20,
        # Velocity: random number between -5 and 5
        dx: rand(11) -5,
        dy: rand(11) -5,
        path: "sprites/misc/wabbit_alpha.png",
        r: rand(255),
        g: rand(255),
        b: rand(255)
      }
  end
end
