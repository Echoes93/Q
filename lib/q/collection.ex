defmodule Q.Collection do
  @moduledoc """
    A set of functions for working with keyword-based collection.
  """

  @type key :: any
  @type value :: any
  @type t :: [{key, value}]


  @doc """
  Returns an empty collection, i.e. an empty list.

  ## Examples
      iex> Q.Collection.new()
      []

  """
  @spec new :: []
  def new, do: []


  @doc """
  Gets the value for a specific `key`.
  If `key` does not exist, returns nil.

  ## Examples
      iex> Q.Collection.get([], "key")
      nil
      iex> Q.Collection.get([{"key", 1}], "key")
      1
      iex> Q.Collection.get([a: 1], :a)
      1
      iex> Q.Collection.get([a: 1], "key")
      nil

  """
  @spec get(t, key) :: value
  def get(collection, key) do
    Enum.reduce_while(collection, nil, fn(pair, acc) ->
      if elem(pair, 0) == key do
        {:halt, elem(pair, 1)}
      else
        {:cont, acc}
      end
    end)
  end



  @doc """
  Puts the given `value` under `key` in `collection`.
  Inlined by the compiler.

  ## Examples
      iex> Q.Collection.put([a: 1], :b, 2)
      [b: 2, a: 1]
      iex> Q.Collection.put([a: 1, b: 2], :a, 3)
      [b: 2, a: 3]

  """
  @spec put(t, key, value) :: t
  def put(collection, key, value) do
    case try_update(collection, key, value) do
      {:updated, new_collection} -> new_collection
      {:not_updated, new_collection} -> [{key, value} | new_collection]
    end
  end


  @doc """
  Deletes the entry in `collection` for a specific `key`.
  If the `key` does not exist, returns `collection` unchanged.

  ## Examples
      iex> Q.Collection.delete([a: 1, b: 2], :a)
      [b: 2]
      iex> Q.Collection.delete([b: 2], :a)
      [b: 2]

  """
  @spec delete(t, key) :: t
  def delete(collection, key) do
    Enum.filter(collection, &(elem(&1, 0) != key))
  end



  defp try_update(collection, key, value) do
    Enum.reduce(collection, {:not_updated, []}, fn (pair, {status, acc}) ->
      if elem(pair, 0) == key do
        {:updated, [{key, value} | acc]}
      else
        {status, [pair | acc]}
      end
    end)
  end
end
