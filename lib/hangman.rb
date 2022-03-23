class Hangman
	attr_accessor :word, :guesses, :correct_letters, :wrong_letters

	private
	def initialize
		@file = File.open("google-10000-english-no-swears.txt")
		@words = @file.readlines.map(&:chomp)
		@words = @words.select { |w| w.length > 5 && w.length < 12 }
		@word = @words.sample.split("")
		@file.close
		@guesses = 0
		@correct_letters = Array.new
		@wrong_letters = Array.new
	end

	public
	def input(letter)
		@letter = letter.downcase

		if @correct_letters.include?(@letter) || @wrong_letters.include?(@letter)
			puts "You've already guessed that letter"
			return
		elsif @word.include?(@letter)
			@correct_letters.push(@letter)
		else
			@wrong_letters.push(@letter)
			@guesses += 1
		end
	end

	def status
		if @guesses >= 8
			return "lose"
		elsif @word.length - 1 == @correct_letters.length
			return "win"
		end
	end

	def show
		@lines = Array.new
		@word.each do |letter|
			if @correct_letters.include?(letter)
				@lines.push(letter)
			else
				@lines.push("_")
			end
		end

		puts "These letters you guessed were incorrect: #{@wrong_letters.join(", ")}"
		if @guesses == 7
			puts "You have 1 guess left"
		else
			puts "You have #{8 - @guesses} guesses left"
		end
		puts @lines.join(" ")

	end
end

class Shell
	def initialize
		game = Hangman.new
		game.show

		while true do
			puts
			print ">"
			player_input = gets.chomp.to_s
			game.input(player_input)
			game.show

			if game.status == "lose"
				puts game.word.join
				puts
				puts "GAME OVER!"
				puts "Computer wins!"
				break
			elsif game.status == "win"
				puts game.word.join
				puts
				puts "GAME OVER!"
				puts "Player wins!"
				break
			end
		end
	end
end

Shell.new