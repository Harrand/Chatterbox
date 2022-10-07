local addon_name, chatter = ...

local function pairs_by_keys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

chatter.quotes = {}
chatter.quotes.edit_mode = false
chatter.quotes.editor = nil

QuoteElement = {timestamp = 0, str = ""}
Quote = {name = "Untitled", elements = {},
	add = function(self, element)
		table.insert(self.elements, element)
	end,
	test = function(self)
		for i, quote in ipairs(self.elements) do
			print("timestamp = " .. quote.timestamp)
			print("str = " .. quote.str)
		end
	end
	}

function get_quote(name)
	for i = 1, #chatter_saved.quotes do
		quote = chatter_saved.quotes[i]
		if quote ~= nil then
			if quote.name == name then
				return quote
			end
		end
	end
	return nil
end


