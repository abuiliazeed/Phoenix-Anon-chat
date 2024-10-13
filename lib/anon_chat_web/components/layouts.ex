defmodule AnonChatWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use AnonChatWeb, :controller` and
  `use AnonChatWeb, :live_view`.
  """
  use AnonChatWeb, :html

  embed_templates "layouts/*"
end
