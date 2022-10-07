local addon_name, chatter = ...

chatter.quotes.edit_mode = false
chatter.quotes.editor = nil

QuoteElement = {timestamp = 0, str = ""}
Quote = {name = "Untitled", elements = {}}

chatter.begin_quote = function(name)
	if chatter.quotes.edit_mode then
		print("Warning: You were already editing a quote. Discarding...")
	end
	print("Entering edit mode for a new quote \"" .. name .. "\"")
	chatter.quotes.edit_mode = true
	chatter.quotes.editor = Quote
	chatter.quotes.editor.name = name
end

chatter.finish_quote = function()
	if ~chatter.quotes.edit_mode then
		print("Error: Cannot finish quote because you weren't editing one")
	end
	chatter.quotes.edit_mode = false
	print("Editing on quote \"" .. chatter.quotes.editor.name .. "\" complete!")
	table.insert(chatter.saved.quotes, chatter.quotes.editor)
	chatter.quotes.editor = nil
end

function Quote::add(element)
	table.insert(self.elements, element)
end

