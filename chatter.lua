local addon_name, chatter = ...

chatter.chat_type = {}
chatter.chat_type["/s"] = "SAY"
chatter.chat_type["/e"] = "EMOTE"
chatter.chat_type["/y"] = "YELL"
chatter.chat_type["/p"] = "PARTY"
chatter.chat_type["/g"] = "GUILD"
chatter.chat_type["/o"] = "OFFICER"
chatter.chat_type["/r"] = "RAID"
chatter.chat_type["/i"] = "INSTANCE"
chatter.chat_type["/bg"] = "BATTLEGROUND"
chatter.chat_type["/w"] = "WHISPER"
chatter.chat_type["/x"] = "CHANNEL"
chatter.chat_type["/0"] = "DEBUG"

chatter.current_chat_type = chatter.chat_type["/s"]
chatter.current_chat_extra = ""

