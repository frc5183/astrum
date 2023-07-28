local ClickNode = require"lib.gui.subsystem.ClickNode"
return {
  AdapterButton=require"lib.gui.element.AdapterButton",
  TextButton=require"lib.gui.element.TextButton",
  VisualButton=require"lib.gui.element.VisualButton",
  ClickOrigin=ClickNode(true, function(a, b, c) return a, b, c end),
  ClickNode = ClickNode,
  Color=require"lib.gui.color",
  TextInput=require"lib.gui.element.TextInput",
  ScrollBar=require"lib.gui.element.ScrollBar"
  }