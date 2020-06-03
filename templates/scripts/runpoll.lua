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
            this.questionNum=1;
            this.leftEmpty="empty gr0";
            this.surveyTitle="survey-title survey-title-started";
            this.runPollButtonClass="run-poll-button run-poll-button-started";
            this.btnWrap="wd0";
            this.innerClass="w100";
            this.outWrap="out-wrap column";
            window:setTimeout(function()
                this.questions="questions op1";
            end,500)
            --window.app.togglePollsText="Свернуть";
        end
    };
	data = Object{
        questionNum=0;
        leftEmpty="empty";
        surveyTitle="survey-title";
        outWrap="out-wrap";
        btnWrap="";
        questions="questions wd0";
        innerClass="";
        runPollButtonClass="run-poll-button";
	}
})

this=window.app