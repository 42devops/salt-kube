import json
import requests


def slack_notify(channel, pretext, text, level="warning"):
    headers = {"Content-Type": "application/json"}
    body = {
        "attachments": [{"color": level, "pretext": pretext, "text": text}],
        "channel": channel,
        "username": "salt-bot",
        "icon_emoji": ":robot_face:",
    }

    response = requests.post(
        url="https://hooks.slack.com/APIWIHTTOKEN",
        data=json.dumps(body),
        headers=headers,
    )
    return response


def notify(channel, data_str):
    data = eval(data_str)
    error = False
    if "retcode" in data:
        if type(data["return"]) is dict:
            if not all([x["result"] for x in data["return"].values()]):
                error = True
                text = "\n".join(
                    [x["comment"] for x in data["return"].values() if not x["result"]]
                )
        else:
            error = True
            text = "```\n%s\n```" % "\n".join(data["return"])

    if error:
        pretext = "`%s` has error when running `%s`" % (data["tgt"], data["fun"])
        slack_notify(channel, pretext, text)
    return True
