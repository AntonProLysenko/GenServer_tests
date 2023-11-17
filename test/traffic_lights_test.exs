defmodule TrafficLightsTest do

  use ExUnit.Case


  test "creates new traffic light with state of :green" do
    {:ok, pid} = TrafficLights.Lights.start([])
    assert TrafficLights.Lights.read(pid) == :green
  end

  test "Changes trafic light to a next collor" do
     {:ok, pid} = TrafficLights.Lights.start([])
     TrafficLights.Lights.transition(pid)
     assert TrafficLights.Lights.read(pid) == :yellow
    TrafficLights.Lights.transition(pid)
     assert TrafficLights.Lights.read(pid) == :red
  end

  test "Looping colors" do
    {:ok, pid} = TrafficLights.Lights.start([])
    assert TrafficLights.Lights.read(pid) == :green
    TrafficLights.Lights.transition(pid)
    assert TrafficLights.Lights.read(pid) == :yellow
    TrafficLights.Lights.transition(pid)
    assert TrafficLights.Lights.read(pid) == :red
    TrafficLights.Lights.transition(pid)
    assert TrafficLights.Lights.read(pid) == :green
    TrafficLights.Lights.transition(pid)
    TrafficLights.Lights.transition(pid)
    assert TrafficLights.Lights.read(pid) == :red
  end


  test "Creating a grid of five trafic lights" do
    {:ok, pid} = TrafficLights.Grid.start([])
    assert TrafficLights.Grid.read(pid) == [:green, :green, :green, :green, :green]
  end

  test "Transitin one light per request" do
     {:ok, pid} = TrafficLights.Grid.start([])
     TrafficLights.Grid.transition(pid)
     assert TrafficLights.Grid.read(pid) == [:yellow, :green, :green, :green, :green]
  end

  test "Transitin one light per reques multiple light and looping over each color" do
    {:ok, pid} = TrafficLights.Grid.start([])
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    assert TrafficLights.Grid.read(pid) == [:red, :yellow, :yellow, :yellow, :yellow]
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    assert TrafficLights.Grid.read(pid) == [:green, :green, :red, :red, :red]
  end


end
