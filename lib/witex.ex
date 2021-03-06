defmodule Witex do
  use Application
  use HTTPoison.Base

  @http_module Application.get_env(:witex, :http_module, HTTPoison)

  def start(_type, _args) do
    check_configuration()
    Witex.Supervisor.start_link
  end

  @spec get(binary, headers, Keyword.t) :: {:ok, Response.t | AsyncResponse.t} | {:error, Error.t}
  def get(url, headers \\ [], options \\ []), do: @http_module.request(:get, url, "", headers, options)

  @spec get!(binary, headers, Keyword.t) :: Response.t | AsyncResponse.t
  def get!(url, headers \\ [], options \\ []), do: @http_module.request!(:get, url, "", headers, options)

  @spec post(binary, body, headers, Keyword.t) :: {:ok, Response.t | AsyncResponse.t} | {:error, Error.t}
  def post(url, body, headers \\ [], options \\ []), do: @http_module.request(:post, url, body, headers, options)

  @spec post!(binary, body, headers, Keyword.t) :: Response.t | AsyncResponse.t
  def post!(url, body, headers \\ [], options \\ []), do: @http_module.request!(:post, url, body, headers, options)

  @endpoint Application.get_env(:witex, :api)

  @spec process_url(binary) :: binary
  defp process_url(url), do: @endpoint <> url

  # Called to arbitrarly process the request body before sending it with the
  # request.
  @spec process_request_body(term) :: binary
  defp process_request_body(body), do: JSX.encode!(body)

  # Called to arbitrarly process the request headers before sending them
  # with the request.
  @spec process_request_headers(term) :: [{binary, term}]
  defp process_request_headers(headers) do
    headers
     |> authorization_header
     |> user_agent
     |> content_type
  end

  # Called before returning the response body returned by a request to the
  # caller.
  @spec process_response_body(binary) :: term
  defp process_response_body(body) do
    JSX.decode!(body, [{:labels, :atom}])
  end

  defp authorization_header(headers) do
   token = Application.get_env(:witex, :api_token)
   [{"Authorization", "Bearer #{token}"} | headers]
  end

  defp content_type(headers) do
   [{"Content-type", "application/json"} | headers]
  end

  defp user_agent(headers) do
   [{"User-agent", "witex"} | headers]
  end

  # Used when an async request is made; it's called on each chunk that gets
  # streamed before returning it to the streaming destination.
  # @spec process_response_chunk(binary) :: term
  # defp process_response_chunk(chunk)

  # Called to process the response headers before returing them to the
  # caller.
  # @spec process_headers([{binary, term}]) :: term
  # defp process_headers(headers)

  # Used to arbitrarly process the status code of a response before
  # returning it to the caller.
  # @spec process_status_code(integer) :: term
  # defp process_status_code(status_code)

  # def get(path, args \\ []) do
  #   base_url = construct_url(path)
  #   url = append_args(base_url, args)
  #   witex_request(:get, url)
  # end

  # defp append_args(url, args) do
  #   qs = URI.encode_query(args)
  #   case qs do
  #     "" -> url
  #     _ -> "#{url}?#{qs}"
  #   end
  # end

  # defp witex_request(method, url, body \\ "", options \\ []) do
  #   headers = []
  #     |> authorization_header
  #     |> user_agent
  #     |> content_type
  #   request!(method, url, , headers, options).body
  # end

  def version do
    {{yyyy, mm, dd}, _} = :calendar.universal_time
    mm = String.rjust("#{mm}", 2, ?0)
    dd = String.rjust("#{dd}", 2, ?0)
    "#{yyyy}#{mm}#{dd}"
  end

  defp check_configuration do
    if !Application.get_env(:witex, :api), do: raise "Missing config/config.exs values"
    if !Application.get_env(:witex, :api_token), do: raise "Missing config/config.exs values"
    if !Application.get_env(:witex, :bubu), do: raise "Missing config/config.exs values"
  end
end
