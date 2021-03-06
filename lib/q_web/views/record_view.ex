defmodule QWeb.RecordView do
  use QWeb, :view
  alias QWeb.RecordView

  def render("index.json", %{records: records}) do
    %{data: render_many(records, RecordView, "record.json", as: :record)}
  end

  def render("show.json", %{record: record}) do
    %{data: render_one(record, RecordView, "record.json", as: :record)}
  end

  def render("record.json", %{record: {key, value}}) do
    %{"key" => key, "value" => value}
  end
end
