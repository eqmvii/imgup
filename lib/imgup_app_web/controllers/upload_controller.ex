defmodule ImgupAppWeb.UploadController do
  use ImgupAppWeb, :controller

  # TODO ERIC - this doesn't work at all in this file, weird?
  # alias ImgupAppWeb.Router.Helpers, as: Routes

  def upload(conn, %{"file" => upload} = _params) do
    # Randomly test ex aws functionality via listing s3 objects in test bucket
    # raise inspect ExAws.S3.list_objects(System.get_env("IMGUP_BUCKET_NAME")) |> ExAws.request()

    # Extract file information for debugging during testing
    %Plug.Upload{filename: filename, path: path, content_type: content_type} = upload

    timestamp = :os.system_time(:second)
    s3_key = "local/hacking/imgup_testing_#{timestamp}_#{filename}"
    case upload_file(path, s3_key) do
      {:ok, _junk} ->
          IO.puts "uploaded #{s3_key} succesfully"
          # TODO ERIC - extract the image url from the S3 key
      {:error, message} -> raise inspect message
    end

    # TODO cleanup
    # raise inspect params, pretty: true

    # Inspect the uploaded file
    IO.puts("Filename: #{filename}\n")
    IO.puts("Path: #{path}\n")
    IO.puts("Content type: #{content_type}\n")

    conn
    |> put_flash(:info, "File #{filename} uploaded successfully!")
    # redirect(conn, to: Routes.image_path(conn, :display, image_url: image_url))
    # |> redirect(to: "/behold")
    # |> redirect(to: ImgupAppWeb.Router.Helpers.page_path(conn, :behold, image_url: s3_key))
    # TODO ERIC route this better
    |> redirect(to: "/behold?image_url=#{s3_key}")
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
