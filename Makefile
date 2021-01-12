FORMATTER_OPTIONS = --swiftversion 5.3\
	--self insert\
	--disable blankLinesAtStartOfScope,blankLinesAtEndOfScope,unusedArguments,andOperator,preferKeyPath,wrapMultilineStatementBraces\
	--ifdef no-indent
HEADER = ""

format:
	swiftformat --header $(HEADER) $(FORMATTER_OPTIONS) .
