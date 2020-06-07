local js = require "js"
local window = js.global

package.loadlib("/static/lib/vue.js", "*")
package.loadlib("/static/lib/vuesax.min.js","*")


local Object = dofile("https://gist.githubusercontent.com/daurnimator/5a7fa933e96e14333962093322e0ff95/raw/8c6968be0111c7becc485a692162ad100e87d9c7/Object.lua").Object
local Inspect = dofile("https://raw.githubusercontent.com/kikito/inspect.lua/master/inspect.lua")

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
                    this.availableAnswers = window.questions[this.questionNum].answers;
                    print("set");
                    --for i=1,#this.availableAnswers do
                    --    print(this.availableAnswers[i])
                    --end
                    --print("===")
                    this.questionTextClass="question-1";
                else
                    this.ended = true;
                    this.questionTextClass="question-1";
                    print("end")
                    this.mainPart="dnone";
                    this.questionsEnd="questions op1";

                    window.resarr = window:arr()
                    for i=1,#this.answers do
                        print(Inspect.inspect(this.answers[i]))
                        window.resarr:push(this.answers[i])
                    end
                    js.global:fetch('/pollsave', Object{
                        method = "POST",
                        headers =  Object{
                            ['Accept'] = 'application/json',
                            ['Content-Type'] = 'application/json'
                        },
                        body = window.JSON:stringify(Object{
                            pollId=this.pollId,
                            answers = window.resarr,
                            questions = window.questionIds,
                        })
                    })
                    --this.questions="questions wd0";
                end
            end,500)
        end;
        answer=function(t,ans)
            this:nextQuestion();
            print(ans)
            this.answers[#this.answers+1]=ans;
            --print(Inspect.inspect(this.answers));
        end
    };
	data = Object{
        questionNum=1;
        question = window.questions[1].text;
        leftEmpty="empty";
        surveyTitle="survey-title";
        outWrap="out-wrap";
        mainPart="";
        answers={};
        btnWrap="";
        questions="questions wd0";
        innerClass="";
        questionsEnd="dnone";
        ended = false;
        questionTextClass="question-1";
        runPollButtonClass="run-poll-button";
        pollId=window.pollId;
        availableAnswers = window.questions[1].answers;
	}
})

this=window.app