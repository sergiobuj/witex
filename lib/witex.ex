defmodule Witex do
  @empty_outcome %{confidence: 0}

  def message(message) do
    params = %{
      q: message,
      v: Witex.version
    }

    #{:ok, response} = WitexHTTP.get("message", [], [params: params])
    {:ok, response} = WitexHTTP.get("17pb2yq1", [], [params: params])
    response.body
  end

  def best_outcome(intent) do
    outcomes = intent[:outcomes]
    if length(outcomes) do
      Enum.reduce(outcomes, @empty_outcome, &compare_confidence(&1, &2))
    end
  end

  def entities(outcome) do

  end

  defp compare_confidence(outcome_a, outcome_b) do
    if outcome_a.confidence >= outcome_b.confidence, do: outcome_a, else: outcome_b
  end

  def version do
    {{yyyy, mm, dd}, _} = :calendar.universal_time
    mm = String.rjust("#{mm}", 2, ?0)
    dd = String.rjust("#{dd}", 2, ?0)
    "#{yyyy}#{mm}#{dd}"
  end
end
