defmodule Witex.Message do
  @empty_outcome %{confidence: 0}

  def intent(message) do
    params = %{
      q: message,
      v: Witex.version
    }

    {:ok, response} = Witex.get("message", [], [params: params])
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
end
