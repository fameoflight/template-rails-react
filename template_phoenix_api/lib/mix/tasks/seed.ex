defmodule Mix.Tasks.Seed do
  @moduledoc """
  Custom mix task for seeding the database.
  
  Similar to Rails' `rails db:seed` command.
  
  ## Examples
  
      # Seed with default seeds.exs
      mix seed
      
      # Seed with specific file
      mix seed --file priv/repo/custom_seeds.exs
      
      # Force seed even in production
      mix seed --force
      
      # Reset database and seed
      mix seed --reset
  """
  
  @shortdoc "Seeds the database"
  
  use Mix.Task
  
  @impl Mix.Task
  def run(args) do
    {options, _, _} = OptionParser.parse(args, 
      switches: [
        file: :string,
        force: :boolean,
        reset: :boolean,
        help: :boolean
      ],
      aliases: [
        f: :file,
        h: :help
      ]
    )
    
    if options[:help] do
      print_help()
    else
      seed_database(options)
    end
  end
  
  defp seed_database(options) do
    # Start the application
    Mix.Task.run("app.start")
    
    # Check environment safety
    if Mix.env() == :prod and not options[:force] do
      Mix.shell().error("Refusing to seed production database without --force flag")
      System.halt(1)
    end
    
    # Reset database if requested
    if options[:reset] do
      Mix.shell().info("🗑️  Resetting database...")
      Mix.Task.run("ecto.reset", ["--quiet"])
    end
    
    # Determine seed file
    seed_file = options[:file] || "priv/repo/seeds.exs"
    
    # Check if seed file exists
    unless File.exists?(seed_file) do
      Mix.shell().error("Seed file not found: #{seed_file}")
      System.halt(1)
    end
    
    # Run the seed file
    Mix.shell().info("🌱 Running seeds from #{seed_file}...")
    
    try do
      Code.eval_file(seed_file)
      Mix.shell().info("✅ Seeding completed successfully!")
    rescue
      error ->
        Mix.shell().error("❌ Seeding failed: #{Exception.message(error)}")
        if Mix.debug?() do
          Mix.shell().error(Exception.format_stacktrace(__STACKTRACE__))
        end
        System.halt(1)
    end
  end
  
  defp print_help do
    Mix.shell().info """
    mix seed - Seeds the database
    
    ## Options
    
        --file, -f    Specify custom seed file (default: priv/repo/seeds.exs)
        --force       Force seeding in production environment
        --reset       Reset database before seeding
        --help, -h    Show this help
    
    ## Examples
    
        mix seed                                    # Run default seeds
        mix seed --file priv/repo/test_seeds.exs   # Run custom seed file  
        mix seed --reset                           # Reset DB and seed
        mix seed --force                           # Force seed in production
    """
  end
end