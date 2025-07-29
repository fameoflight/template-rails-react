defmodule TemplatePhoenixApi.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias TemplatePhoenixApi.Repo
  alias TemplatePhoenixApi.Jobs.JobRecord

  @doc """
  Returns the list of job_records.
  """
  def list_job_records do
    Repo.all(JobRecord)
  end

  @doc """
  Gets a single job_record.
  """
  def get_job_record!(id), do: Repo.get!(JobRecord, id)

  @doc """
  Gets a single job_record.
  """
  def get_job_record(id), do: Repo.get(JobRecord, id)

  @doc """
  Creates a job_record.
  """
  def create_job_record(attrs \\ %{}) do
    %JobRecord{}
    |> JobRecord.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a job_record.
  """
  def update_job_record(%JobRecord{} = job_record, attrs) do
    job_record
    |> JobRecord.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a job_record.
  """
  def delete_job_record(%JobRecord{} = job_record) do
    Repo.delete(job_record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job_record changes.
  """
  def change_job_record(%JobRecord{} = job_record, attrs \\ %{}) do
    JobRecord.changeset(job_record, attrs)
  end
end