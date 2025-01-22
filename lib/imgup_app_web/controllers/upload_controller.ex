defmodule ImgupAppWeb.UploadController do
  use ImgupAppWeb, :controller

  def upload(conn, %{"file" => upload} = params) do
    # Extract file information for debugging during testing
    %Plug.Upload{filename: filename, path: path, content_type: content_type} = upload

    # TODO cleanup
    # raise inspect params, pretty: true

    # Inspect the uploaded file
    IO.puts("Filename: #{filename}\n")
    IO.puts("Path: #{path}\n")
    IO.puts("Content type: #{content_type}\n")

    # Respond to the client
    conn
    |> put_flash(:info, "File #{filename} uploaded successfully!")
    |> redirect(to: "/")
  end
end
