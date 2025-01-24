defmodule ImgupAppWeb.UploadController do
  use ImgupAppWeb, :controller

  def upload(conn, %{"file" => upload} = params) do
    # Randomly test ex aws functionality via listing s3 objects in test bucket
    # raise inspect ExAws.S3.list_objects(System.get_env("IMGUP_BUCKET_NAME")) |> ExAws.request()

    # Extract file information for debugging during testing
    %Plug.Upload{filename: filename, path: path, content_type: content_type} = upload

    timestamp = :os.system_time(:second)
    raise inspect upload_file(path, "local/hacking/imgup_testing_#{filename}_#{timestamp}")

    # TODO cleanup
    # raise inspect params, pretty: true

    # Inspect the uploaded file
    IO.puts("Filename: #{filename}\n")
    IO.puts("Path: #{path}\n")
    IO.puts("Content type: #{content_type}\n")

    conn
    |> put_flash(:info, "File #{filename} uploaded successfully!")
    |> redirect(to: "/")
  end

  ###################
  # Private Methods #
  ###################

  defp upload_file(file_path, s3_key) do
    file_path
    |> File.read()
    |> case do
      {:ok, file_content} ->
        ExAws.S3.put_object(System.get_env("IMGUP_BUCKET_NAME"), s3_key, file_content)
        |> ExAws.request()

      {:error, reason} ->
        {:error, "Failed to read file: #{reason}"}
    end
  end

end
