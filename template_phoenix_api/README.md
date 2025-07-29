# TemplatePhoenixApi

A Phoenix GraphQL API with authentication, content management, and file handling capabilities. This is a feature-complete backend API similar to the Rails version, built with Phoenix, Absinthe (GraphQL), and PostgreSQL.

## Features

- 🔐 **Authentication & Authorization**: User registration, login, email confirmation, password reset, 2FA/OTP
- 📊 **GraphQL API**: Complete GraphQL schema with queries, mutations, and subscriptions
- 👤 **User Management**: User profiles, API tokens, admin/super user functionality  
- 📝 **Content Management**: Blog posts, comments, rich text content
- 📎 **File Handling**: Direct uploads, attachments, polymorphic file associations
- 🔍 **Search & Filtering**: Blog post filtering, user search
- 🌱 **Database Seeding**: Rails-like seeding system for development and testing
- ✅ **Comprehensive Testing**: 71 tests covering all functionality
- 🏗️ **Background Jobs**: Email processing with Oban
- 📧 **Email System**: Postmark integration for transactional emails

## Quick Start

### Prerequisites

- Elixir 1.18+ and Erlang/OTP 26+
- PostgreSQL 14+
- Node.js 18+ (for asset compilation)

### Setup

1. **Clone and install dependencies:**
   ```bash
   git clone <repository-url>
   cd template_phoenix_api
   mix setup
   ```

2. **Configure your database:**
   ```bash
   # Edit config/dev.exs with your PostgreSQL settings
   mix ecto.create
   mix ecto.migrate
   ```

3. **Seed the database:**
   ```bash
   mix seed
   ```

4. **Start the server:**
   ```bash
   mix phx.server
   ```

Visit [`localhost:5001`](http://localhost:5001) - the GraphQL playground will be available at [`localhost:5001/api/graphql`](http://localhost:5001/api/graphql).

## GraphQL Schema

### Building and Working with the Schema

#### Generate Schema File

To generate the GraphQL schema file (SDL format):

```bash
# Generate schema.graphql file
mix absinthe.schema.sdl --schema TemplatePhoenixApiWeb.Schema

# Output location: ./schema.graphql
```

#### Schema Location and Structure

The GraphQL schema is defined in:
```
lib/template_phoenix_api_web/schema/
├── schema.ex              # Main schema definition
├── types/
│   ├── auth.ex           # Authentication types and mutations
│   ├── user.ex           # User types and queries  
│   ├── content.ex        # Blog posts, comments
│   ├── interfaces.ex     # GraphQL interfaces (Node, ModelInterface)
│   ├── extended_mutations.ex # Advanced mutations
│   └── placeholder_types.ex  # Additional types
```

#### Schema Development Workflow

1. **Add new types:**
   ```elixir
   # lib/template_phoenix_api_web/schema/types/my_type.ex
   defmodule TemplatePhoenixApiWeb.Schema.Types.MyType do
     use Absinthe.Schema.Notation
     
     object :my_type do
       field :id, non_null(:id)
       field :name, :string
       # ... more fields
     end
   end
   ```

2. **Register in main schema:**
   ```elixir
   # lib/template_phoenix_api_web/schema.ex
   import_types TemplatePhoenixApiWeb.Schema.Types.MyType
   ```

3. **Regenerate schema file:**
   ```bash
   mix absinthe.schema.sdl --schema TemplatePhoenixApiWeb.Schema
   ```

4. **Validate with tests:**
   ```bash
   mix test test/template_phoenix_api_web/schema/
   ```

#### Schema Comparison with Rails

To compare schemas between Phoenix and Rails:

```bash
# Phoenix schema (generated above)
./schema.graphql

# Rails schema (if available)
../template-web/data/schema.graphql

# Use any diff tool to compare
diff ./schema.graphql ../template-web/data/schema.graphql
```

### Key Schema Features

#### Core Types
- **User**: User accounts with authentication
- **BlogPost**: Content with rich text and status
- **Comment**: User comments with ratings
- **Attachment**: File attachments with polymorphic associations
- **ApiAccessToken**: API authentication tokens

#### Interfaces
- **Node**: Relay-style global ID interface
- **ModelInterface**: Common fields (id, createdAt, updatedAt, modelId)

#### Authentication
```graphql
# Register new user
mutation {
  register(input: {
    email: "user@example.com"
    name: "John Doe" 
    password: "password123"
  }) {
    user { id email name }
    token
  }
}

# Login
mutation {
  login(input: {
    email: "user@example.com"
    password: "password123"
  }) {
    user { id email name }
    token
  }
}
```

#### Content Queries
```graphql
# Get current user
query {
  currentUser {
    id
    email
    name
    confirmed
    otpEnabled
  }
}

# Get blog posts
query {
  blogPosts(status: PUBLISHED) {
    id
    title
    status
    publishedAt
    richTextContent {
      content
      contentHtml
      format
    }
  }
}
```

#### File Uploads
```graphql
# Create direct upload
mutation {
  createDirectUpload(input: {
    filename: "image.jpg"
    contentType: "image/jpeg"
    byteSize: 1024
    checksum: "abc123"
  }) {
    directUpload {
      id
      signedId
      directUploadUrl
      directUploadHeaders
    }
  }
}
```

## Database Seeding

This project includes a comprehensive Rails-like seeding system:

### Basic Usage
```bash
# Seed development database
mix seed

# Reset database and seed
mix seed --reset

# Use custom seed file
mix seed --file priv/repo/test_seeds.exs

# Force seed in production (careful!)
mix seed --force --file priv/repo/production_seeds.exs
```

### Seed Data Created
- **Users**: Admin (`admin@test.com`), regular (`user@test.com`), unconfirmed, OTP-enabled
- **Content**: Sample blog posts, comments with ratings
- **Attachments**: Sample file attachments and associations
- **API Tokens**: Development and test API access tokens

### Custom Seeding
```elixir
# priv/repo/seeds/my_seeds.exs
defmodule TemplatePhoenixApi.Seeds.MySeeds do
  alias TemplatePhoenixApi.{Repo, Accounts}
  
  def seed do
    # Create custom data
    {:ok, user} = Accounts.create_user(%{
      email: "custom@example.com",
      name: "Custom User"
    })
  end
end
```

See [SEEDS.md](priv/repo/SEEDS.md) for comprehensive seeding documentation.

## Testing

The project includes comprehensive test coverage:

```bash
# Run all tests
mix test

# Run specific test files
mix test test/template_phoenix_api_web/schema/
mix test test/template_phoenix_api/accounts_test.exs

# Run with coverage
mix test --cover

# Tests: 71 tests, covering:
# - Authentication flows
# - GraphQL queries and mutations  
# - User management
# - Content management
# - File handling
# - Background jobs
```

## API Endpoints

### GraphQL
- **Endpoint**: `POST /api/graphql`
- **Playground**: `GET /api/graphql` (development only)
- **Authentication**: Bearer token in Authorization header

### REST Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login  
- `POST /api/auth/confirm/:token` - Email confirmation
- `POST /api/auth/forgot_password` - Password reset request
- `POST /api/auth/reset_password` - Password reset
- `GET /api/auth/me` - Current user (authenticated)
- `DELETE /api/auth/logout` - Logout

### Health Check
- `GET /api/health` - Application health status

## Configuration

### Environment Variables

#### Development
```bash
# Database
DATABASE_URL="postgresql://user:pass@localhost/template_phoenix_api_dev"

# Email (optional for development)
POSTMARK_API_KEY="your-postmark-key"
FROM_EMAIL="noreply@yourapp.com"
```

#### Production
```bash
# Required
DATABASE_URL="postgresql://..."
SECRET_KEY_BASE="your-secret-key"
POSTMARK_API_KEY="your-postmark-key"
FROM_EMAIL="noreply@yourapp.com"

# For seeding
ADMIN_EMAIL="admin@yourapp.com"
ADMIN_PASSWORD="secure-password"
```

### Configuration Files
- `config/config.exs` - Shared configuration
- `config/dev.exs` - Development settings
- `config/prod.exs` - Production settings  
- `config/test.exs` - Test environment

## Background Jobs

This application uses [Oban](https://hexdocs.pm/oban/) for reliable background job processing. Jobs are persisted in PostgreSQL and processed asynchronously.

### Job Configuration

Oban is configured in `config/config.exs`:
```elixir
config :template_phoenix_api, Oban,
  repo: TemplatePhoenixApi.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [
    default: [limit: 10],
    mailer: [limit: 20]
  ]
```

### Running Background Jobs

#### Development
Jobs run automatically when you start the Phoenix server:
```bash
mix phx.server
# Jobs will be processed in the background
```

#### Production
Background jobs run automatically with the main application. For more control:

```bash
# Start with specific queues
OBAN_QUEUES="default:5,mailer:10" mix phx.server

# Disable job processing (only queue jobs)
OBAN_QUEUES="" mix phx.server

# Check job status
mix run -e "IO.inspect(Oban.check_queue(:default))"
```

#### Standalone Job Processing
Run only job processing without the web server:
```bash
# Create a job-only runner script
# lib/template_phoenix_api/job_runner.ex
defmodule TemplatePhoenixApi.JobRunner do
  def start do
    # Start only necessary services
    {:ok, _} = Application.ensure_all_started(:template_phoenix_api)
    
    # Keep alive
    Process.sleep(:infinity)
  end
end

# Run it
mix run -e "TemplatePhoenixApi.JobRunner.start()"
```

### Available Workers

#### EmailWorker
Handles all email operations:

```elixir
# Queue confirmation email
TemplatePhoenixApi.Workers.EmailWorker.new(%{
  "type" => "confirmation_email",
  "user_id" => user.id
})
|> Oban.insert()

# Queue password reset email
TemplatePhoenixApi.Workers.EmailWorker.new(%{
  "type" => "password_reset",
  "user_id" => user.id,
  "token" => reset_token
})
|> Oban.insert()

# Queue with delay and retry options
TemplatePhoenixApi.Workers.EmailWorker.new(
  %{"type" => "welcome_email", "user_id" => user.id},
  schedule_in: 60,  # Send in 60 seconds
  max_attempts: 5,  # Retry up to 5 times
  queue: :mailer    # Use mailer queue
)
|> Oban.insert()
```

Supported email types:
- `"confirmation_email"` - Account confirmation
- `"password_reset"` - Password reset instructions
- `"welcome_email"` - Welcome new users
- `"notification_email"` - General notifications

#### Creating Custom Workers

```elixir
# lib/template_phoenix_api/workers/my_worker.ex
defmodule TemplatePhoenixApi.Workers.MyWorker do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"action" => "process_data", "data_id" => data_id}}) do
    # Your job logic here
    process_data(data_id)
    :ok
  end

  def perform(%Oban.Job{args: %{"action" => "cleanup"}}) do
    # Cleanup logic
    cleanup_old_records()
    :ok
  end

  defp process_data(data_id) do
    # Implementation
  end

  defp cleanup_old_records do
    # Implementation
  end
end

# Queue the job
TemplatePhoenixApi.Workers.MyWorker.new(%{
  "action" => "process_data",
  "data_id" => 123
})
|> Oban.insert()
```

### Job Management

#### Monitoring Jobs

**Via IEx:**
```elixir
# Start IEx with app
iex -S mix phx.server

# Check queue states
Oban.check_queue(:default)
Oban.check_queue(:mailer)

# List jobs
alias TemplatePhoenixApi.Repo
import Ecto.Query

# Pending jobs
from(j in Oban.Job, where: j.state == "available") |> Repo.all()

# Failed jobs
from(j in Oban.Job, where: j.state == "retryable") |> Repo.all()

# Completed jobs (last 100)
from(j in Oban.Job, where: j.state == "completed", order_by: [desc: j.completed_at], limit: 100) |> Repo.all()
```

**Via Database:**
```sql
-- Connect to PostgreSQL
psql -d template_phoenix_api_dev

-- Check job states
SELECT state, count(*) FROM oban_jobs GROUP BY state;

-- Recent jobs
SELECT id, worker, args, state, inserted_at, completed_at 
FROM oban_jobs 
ORDER BY inserted_at DESC 
LIMIT 10;

-- Failed jobs
SELECT id, worker, args, errors, attempted_at
FROM oban_jobs 
WHERE state = 'retryable'
ORDER BY attempted_at DESC;
```

#### Job Operations

```elixir
# Cancel a job (before execution)
Oban.cancel_job(job_id)

# Retry a failed job
job = Repo.get(Oban.Job, job_id)
Oban.retry_job(job)

# Delete completed jobs (careful!)
Oban.drain_queue(queue: :default, with_completed: true)

# Pause/resume queues
Oban.pause_queue(queue: :mailer)
Oban.resume_queue(queue: :mailer)

# Scale queue workers
Oban.scale_queue(queue: :default, limit: 20)
```

### Error Handling and Debugging

#### Worker Error Handling
```elixir
defmodule TemplatePhoenixApi.Workers.MyWorker do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl Oban.Worker
  def perform(%Oban.Job{args: args} = job) do
    case process_job(args) do
      :ok -> 
        :ok
      {:error, :temporary} -> 
        # Will retry according to backoff
        {:error, "Temporary failure, will retry"}
      {:error, :permanent} -> 
        # Will not retry
        {:discard, "Permanent failure, not retrying"}
      {:error, reason} -> 
        # Log error and retry
        Logger.error("Job failed: #{inspect(reason)}")
        {:error, reason}
    end
  rescue
    exception ->
      # Log exception and retry
      Logger.error("Job exception: #{Exception.message(exception)}")
      {:error, Exception.message(exception)}
  end

  defp process_job(args) do
    # Your implementation
  end
end
```

#### Debugging Failed Jobs
```elixir
# In IEx
alias TemplatePhoenixApi.Repo
import Ecto.Query

# Get failed job details
failed_job = from(j in Oban.Job, 
  where: j.state == "retryable", 
  order_by: [desc: j.attempted_at], 
  limit: 1
) |> Repo.one()

# Inspect the job
IO.inspect(failed_job, pretty: true)

# Check errors
IO.inspect(failed_job.errors, pretty: true)

# Manually test the worker
worker_module = String.to_existing_atom("Elixir." <> failed_job.worker)
worker_module.perform(%Oban.Job{args: failed_job.args})
```

### Scheduled and Recurring Jobs

#### Scheduled Jobs
```elixir
# Schedule for specific time
run_time = DateTime.add(DateTime.utc_now(), 3600, :second) # 1 hour from now

TemplatePhoenixApi.Workers.EmailWorker.new(
  %{"type" => "reminder_email", "user_id" => user.id},
  scheduled_at: run_time
)
|> Oban.insert()
```

#### Recurring Jobs with Cron
Add to your supervision tree:
```elixir
# lib/template_phoenix_api/application.ex
def start(_type, _args) do
  children = [
    # ... existing children
    {Oban.Plugins.Cron, 
      crontab: [
        {"0 2 * * *", TemplatePhoenixApi.Workers.CleanupWorker, args: %{"action" => "daily_cleanup"}},
        {"0 0 * * 0", TemplatePhoenixApi.Workers.ReportWorker, args: %{"type" => "weekly_report"}},
      ]
    }
  ]
  
  opts = [strategy: :one_for_one, name: TemplatePhoenixApi.Supervisor]
  Supervisor.start_link(children, opts)
end
```

### Performance and Scaling

#### Queue Configuration
```elixir
# config/prod.exs
config :template_phoenix_api, Oban,
  repo: TemplatePhoenixApi.Repo,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 300}, # Keep jobs for 5 minutes
    {Oban.Plugins.Cron, crontab: [
      # Your cron jobs
    ]}
  ],
  queues: [
    default: [limit: 50],    # High concurrency for general jobs
    mailer: [limit: 10],     # Moderate for emails
    critical: [limit: 5],    # Low concurrency for important jobs
    background: [limit: 2]   # Very low for heavy background tasks
  ]
```

#### Monitoring in Production
```elixir
# Set up telemetry for monitoring
# lib/template_phoenix_api_web/telemetry.ex
defmodule TemplatePhoenixApiWeb.Telemetry do
  def init do
    :telemetry.attach_many(
      "oban-telemetry",
      [
        [:oban, :job, :start],
        [:oban, :job, :stop],
        [:oban, :job, :exception]
      ],
      &handle_oban_event/4,
      nil
    )
  end

  def handle_oban_event([:oban, :job, :start], _measurements, metadata, _config) do
    Logger.info("Job started: #{metadata.worker}")
  end

  def handle_oban_event([:oban, :job, :stop], measurements, metadata, _config) do
    Logger.info("Job completed: #{metadata.worker} in #{measurements.duration}ms")
  end

  def handle_oban_event([:oban, :job, :exception], _measurements, metadata, _config) do
    Logger.error("Job failed: #{metadata.worker} - #{inspect(metadata.error)}")
  end
end
```

### Testing Background Jobs

#### Test Helpers
```elixir
# test/support/oban_helpers.ex
defmodule TemplatePhoenixApi.ObanHelpers do
  def drain_jobs do
    Oban.drain_queue(queue: :default)
    Oban.drain_queue(queue: :mailer)
  end

  def assert_job_enqueued(worker, args) do
    assert_enqueued(worker: worker, args: args)
  end

  def perform_job(worker, args) do
    worker.perform(%Oban.Job{args: args})
  end
end
```

#### Test Configuration
```elixir
# config/test.exs
config :template_phoenix_api, Oban,
  repo: TemplatePhoenixApi.Repo,
  plugins: false,  # Disable plugins in test
  queues: false    # Don't process jobs automatically
```

#### Testing Jobs
```elixir
# test/workers/email_worker_test.exs
defmodule TemplatePhoenixApi.Workers.EmailWorkerTest do
  use TemplatePhoenixApi.DataCase
  use Oban.Testing, repo: TemplatePhoenixApi.Repo
  
  alias TemplatePhoenixApi.Workers.EmailWorker

  test "enqueues confirmation email job" do
    user = insert(:user)
    
    EmailWorker.new(%{
      "type" => "confirmation_email",
      "user_id" => user.id
    })
    |> Oban.insert()

    assert_enqueued(worker: EmailWorker, args: %{
      "type" => "confirmation_email",
      "user_id" => user.id
    })
  end

  test "processes confirmation email job" do
    user = insert(:user)
    
    assert :ok = perform_job(EmailWorker, %{
      "type" => "confirmation_email",
      "user_id" => user.id
    })
    
    # Assert email was sent
    # Add your email assertions here
  end
end
```

### Common Job Patterns

#### Batch Processing
```elixir
# Process records in batches
defmodule TemplatePhoenixApi.Workers.BatchProcessor do
  use Oban.Worker, queue: :background

  def perform(%Oban.Job{args: %{"batch_id" => batch_id, "offset" => offset}}) do
    batch_size = 100
    
    records = get_records(batch_id, offset, batch_size)
    
    Enum.each(records, &process_record/1)
    
    # Queue next batch if more records exist
    if length(records) == batch_size do
      __MODULE__.new(%{
        "batch_id" => batch_id,
        "offset" => offset + batch_size
      })
      |> Oban.insert()
    end
    
    :ok
  end
end
```

#### Job Chaining
```elixir
# Chain dependent jobs
defmodule TemplatePhoenixApi.Workers.ChainedWorker do
  use Oban.Worker

  def perform(%Oban.Job{args: %{"step" => "step1", "data" => data}}) do
    result = process_step1(data)
    
    # Queue next step
    __MODULE__.new(%{"step" => "step2", "data" => result})
    |> Oban.insert()
    
    :ok
  end

  def perform(%Oban.Job{args: %{"step" => "step2", "data" => data}}) do
    process_step2(data)
    :ok
  end
end
```

This comprehensive background job system provides reliable, scalable job processing for your Phoenix application with full monitoring, error handling, and testing capabilities.

## Deployment

### Production Checklist

1. **Environment Setup:**
   ```bash
   export SECRET_KEY_BASE="$(mix phx.gen.secret)"
   export DATABASE_URL="postgresql://..."
   export POSTMARK_API_KEY="your-key"
   ```

2. **Database Migration:**
   ```bash
   mix ecto.create
   mix ecto.migrate
   ```

3. **Seed Production Data:**
   ```bash
   ADMIN_EMAIL="admin@yourapp.com" ADMIN_PASSWORD="secure-pass" mix seed --force --file priv/repo/production_seeds.exs
   ```

4. **Start Application:**
   ```bash
   mix phx.server
   # or with release
   mix release
   _build/prod/rel/template_phoenix_api/bin/template_phoenix_api start
   ```

### Docker

```dockerfile
# Dockerfile example
FROM elixir:1.18-alpine

# Install dependencies
RUN apk add --no-cache build-base postgresql-client

# Set working directory
WORKDIR /app

# Copy mix files
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy application code
COPY . .

# Compile application
RUN mix compile

# Generate release
RUN mix release

# Start application
CMD ["_build/prod/rel/template_phoenix_api/bin/template_phoenix_api", "start"]
```

## Development

### Code Organization
```
lib/
├── template_phoenix_api/           # Core application
│   ├── accounts/                   # User management
│   ├── content/                    # Blog posts, comments
│   ├── admin/                      # Admin functions
│   └── workers/                    # Background jobs
├── template_phoenix_api_web/       # Web interface
│   ├── controllers/                # HTTP controllers
│   ├── schema/                     # GraphQL schema
│   └── plugs/                      # Middleware
└── priv/
    ├── repo/migrations/            # Database migrations
    └── repo/seeds/                 # Database seeds
```

### Adding New Features

1. **Database Schema:**
   ```bash
   mix ecto.gen.migration create_my_feature
   ```

2. **Context and Schema:**
   ```bash
   mix phx.gen.context MyContext MyModel field:type
   ```

3. **GraphQL Types:**
   ```elixir
   # Add to lib/template_phoenix_api_web/schema/types/
   ```

4. **Tests:**
   ```bash
   # Add tests in test/
   mix test
   ```

5. **Update Schema:**
   ```bash
   mix absinthe.schema.sdl --schema TemplatePhoenixApiWeb.Schema
   ```

### Debugging

```bash
# Interactive shell with application loaded
iex -S mix phx.server

# Run specific functions
iex> TemplatePhoenixApi.Accounts.list_users()

# GraphQL query testing
iex> Absinthe.run("{ currentUser { email } }", TemplatePhoenixApiWeb.Schema)
```

## Troubleshooting

### Common Issues

**Database Connection:**
```bash
# Check PostgreSQL is running
pg_ctl status

# Reset database
mix ecto.reset
```

**GraphQL Schema Issues:**
```bash
# Regenerate schema
mix absinthe.schema.sdl --schema TemplatePhoenixApiWeb.Schema

# Check for compilation errors
mix compile --warnings-as-errors
```

**Test Failures:**
```bash
# Run single test
mix test test/path/to/test.exs:line_number

# Reset test database
MIX_ENV=test mix ecto.reset
```

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Make changes with tests
4. Run test suite (`mix test`)
5. Commit changes (`git commit -m 'Add amazing feature'`)
6. Push to branch (`git push origin feature/amazing-feature`)
7. Open Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Related Projects

- **Rails API**: `../template-api/` - Original Rails implementation
- **Frontend**: `../template-web/` - React frontend application
- **Schema Comparison**: Use generated `schema.graphql` to compare with Rails version

---

Ready to run in production? Please [check Phoenix deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn More

- **Phoenix Framework**: https://www.phoenixframework.org/
- **Absinthe GraphQL**: https://hexdocs.pm/absinthe/
- **Ecto Database**: https://hexdocs.pm/ecto/
- **Oban Background Jobs**: https://hexdocs.pm/oban/