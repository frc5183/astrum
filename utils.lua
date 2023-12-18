local gui = require "lib.gui"
local safety = require "lib.safety"
local wait = require "lib.wait"
local state = require "lib.state"
local utils = {}
---A skeleton for creating repetative switch functions
---@param button Button any class which inherits from Button
---@param func function|nil an option function to be ran right before the state switches
---@param state_container {state : table}
function utils.onClickSwitch(button, func, state_container)
  safety.ensureInstanceType(button, gui.Base, "button")
  safety.ensureTable(state_container, "state_container")
  if (not (func == nil)) then -- nilable variable
    safety.ensureFunction(func, "func")
  end
  safety.ensureTable(state_container, "state_container.state")
  if (not button.initButton) then -- Check that base is a button
    error("Button must be a button")
  end
  button:onClick(function(pt, button_id, presses)
    if (button:contains(pt) and button_id == 1) then -- if button 1 clicked within button's bounds
      wait(0.05,                                     -- Wait to prevent double clicking and rubberband hell
        function()
          if (func) then                             -- Allow user to call code before the switch, perhaps to reload the state
            func(state_container)
          end
          state.switch(state_container.state) -- switch to new state
        end)
    end
  end)
end

return utils -- Return utils table
