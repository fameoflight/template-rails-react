defmodule TemplatePhoenixApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :name, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :confirmation_token, :string
    field :confirmed_at, :utc_datetime
    field :confirmation_sent_at, :utc_datetime
    field :reset_password_token, :string
    field :reset_password_sent_at, :utc_datetime
    field :current_sign_in_at, :utc_datetime
    field :last_sign_in_at, :utc_datetime
    field :current_sign_in_ip, :string
    field :last_sign_in_ip, :string
    field :sign_in_count, :integer, default: 0
    field :failed_attempts, :integer, default: 0
    field :locked_at, :utc_datetime
    field :unlock_token, :string
    field :nickname, :string
    field :otp_secret, :string
    field :confirm_on_sign_in, :boolean, default: false
    field :invite_code, :string

    has_many :api_access_tokens, TemplatePhoenixApi.Accounts.ApiAccessToken
    has_many :comments, TemplatePhoenixApi.Content.Comment
    has_many :versions, TemplatePhoenixApi.Audit.Version
    
    has_one :avatar, TemplatePhoenixApi.Content.Attachment,
      foreign_key: :record_id,
      where: [record_type: "User"]

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :nickname, :confirm_on_sign_in, :invite_code, :confirmed_at])
    |> validate_required([:email, :name])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
    |> hash_password()
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required([:password])
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, encrypted_password: Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset

  def verify_password(user, password) do
    Bcrypt.verify_pass(password, user.encrypted_password)
  end

  def first_name(%__MODULE__{name: name, nickname: nickname}) do
    case name do
      nil -> nickname || "User"
      name -> String.split(name) |> List.first() || nickname || "User"
    end
  end

  def otp_enabled?(%__MODULE__{otp_secret: otp_secret}) do
    not is_nil(otp_secret) and String.length(otp_secret || "") > 0
  end

  def confirmed?(%__MODULE__{confirmed_at: confirmed_at}) do
    not is_nil(confirmed_at)
  end

  def locked?(%__MODULE__{locked_at: locked_at}) do
    not is_nil(locked_at)
  end

  def valid_otp?(%__MODULE__{otp_secret: nil}, _otp), do: true
  def valid_otp?(%__MODULE__{otp_secret: ""}, _otp), do: true
  def valid_otp?(%__MODULE__{}, nil), do: false
  def valid_otp?(%__MODULE__{}, ""), do: false
  def valid_otp?(%__MODULE__{otp_secret: otp_secret}, otp) do
    # Convert string OTP to integer
    case Integer.parse(to_string(otp)) do
      {otp_int, ""} -> 
        # Try simple validation first
        :pot.valid_totp(otp_secret, otp_int)
      _ -> 
        false
    end
  end

  def generate_otp_secret do
    # Generate a base32 encoded secret (160 bits / 20 bytes)
    :crypto.strong_rand_bytes(20) |> Base.encode32(padding: false)
  end

  def generate_otp_uri(%__MODULE__{email: email, otp_secret: otp_secret}, issuer \\ "Picasso") do
    # Generate a TOTP URI for QR code generation
    "otpauth://totp/#{issuer}:#{email}?secret=#{otp_secret}&issuer=#{issuer}"
  end

  # Enhanced password validation with OTP support (similar to Rails)
  def verify_password_with_otp(user, password_input) do
    # Try to decode as Base64 JSON payload first
    case decode_password_payload(password_input) do
      {:ok, %{"password" => password, "otp" => otp}} ->
        # JSON payload with both password and OTP
        verify_password(user, password) and valid_otp?(user, otp)

      {:ok, %{"password" => password}} ->
        # JSON payload with password only
        if otp_enabled?(user) do
          # OTP is enabled but no OTP provided
          false
        else
          # OTP not enabled, just verify password  
          verify_password(user, password)
        end

      _error ->
        # Failed to parse as JSON payload
        if otp_enabled?(user) do
          # OTP is enabled but plain password provided
          false
        else
          # OTP not enabled, treat as plain password
          verify_password(user, password_input)
        end
    end
  end

  defp decode_password_payload(password_input) do
    try do
      # Try to decode as base64 first (Rails style)
      case Base.decode64(password_input) do
        {:ok, decoded} ->
          Jason.decode(decoded)

        :error ->
          # Try to decode as plain JSON
          Jason.decode(password_input)
      end
    rescue
      _ -> {:error, :invalid_format}
    end
  end
end
