defmodule ImgupAppWeb.PageController do
  use ImgupAppWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def behold(conn, %{"image_url" => image_url} = _params) do
    # TODO ERIC clean up
    # raise inspect params

    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :behold, layout: false, image_url: image_url)
  end
end
