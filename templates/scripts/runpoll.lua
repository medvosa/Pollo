local js = require "js"
local window = js.global

package.loadlib("https://cdn.jsdelivr.net/npm/vue@2.5.13/dist/vue.js", "*")
package.loadlib("https://unpkg.com/vuesax@4.0.1-alpha.16/dist/vuesax.min.js","*")

local Object = dofile("https://gist.githubusercontent.com/daurnimator/5a7fa933e96e14333962093322e0ff95/raw/8c6968be0111c7becc485a692162ad100e87d9c7/Object.lua").Object


isPollsToggled = false;

local this;

window.app = js.new(js.global.Vue, Object{
	el = "#mainApp";
	methods = Object{
        start = function()
            print("start")
            this.pollNameClass = this.pollNameClass.." poll-name-started"
            this.startClass= this.startClass..' run-poll-button-started';
            this.questionNum=1;
            --window.app.togglePollsText="Свернуть";
        end
    };
	data = Object{
        questionNum=0;
        startClass="run-poll-button";
        pollNameClass="poll-name"
	}
})

this=window.app