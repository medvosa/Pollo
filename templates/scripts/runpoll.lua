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
        end;
        nextQuestion=function()
            this.questionTextClass="question-0";
            window:setTimeout(function()
                this.questionNum=this.questionNum+1;
                if this.questionNum<=#window.questions then
                    this.question = window.questions[this.questionNum].text;
                    this.questionTextClass="question-1";
                else
                    this.ended = true;
                    this.questionTextClass="question-1";
                    print("end")
                    this.mainPart="dnone";
                    this.questionsEnd="questions op1";
                    --this.questions="questions wd0";
                end
            end,500)
        end;
        answer=function(ans)
            this:nextQuestion();
            this.answers[#this.answers+1]=ans;
            print(#this.answers);
        end
    };
	data = Object{
        questionNum=1;
        question = window.questions[1].text;
        leftEmpty="empty";
        surveyTitle="survey-title";
        outWrap="out-wrap";
        mainPart="";
        btnWrap="";
        questions="questions wd0";
        innerClass="";
        questionsEnd="dnone";
        ended = false;
        questionTextClass="question-1";
        runPollButtonClass="run-poll-button";
        answers = {};
	}
})

this=window.app