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
			@amount = @word.count(@letter)
			if @amount > 1
				until @amount == 1
					@correct_letters.push(@letter)
					@amount -= 1
				end
			end
			@correct_letters.push(@letter)
		elsif @word.include?(@letter) == false
			@wrong_letters.push(@letter)
			@guesses += 1
		end
	end

	def save
		File.delete("save") if File.exist?("save")
		File.open("save", "w") do |file|
			file.write(@word.join)
			file.write("\n")
			file.write(@guesses)
			file.write("\n")
			file.write(@correct_letters.join)
			file.write("\n")
			file.write(@wrong_letters.join)
		end
	end

	def load
		File.open("save", "r") do |file|
			@word = Array.new
			@saved_word = file.readline().split("")
			@saved_word.each do |letter|
				@word.push(letter)
			end

			@guesses = file.readline().to_i

			@correct_letters = Array.new
			@saved_correct_letters = file.readline().split("")
			@saved_correct_letters.each do |letter|
				@correct_letters.push(letter)
			end

			@wrong_letters = Array.new
			@saved_wrong_letters = file.readline().split("")
			@saved_wrong_letters.each do |letter|
				@wrong_letters.push(letter)
			end
		end
	end

	def status
		if @guesses == 8
			return "lose"
		elsif @word.length == @correct_letters.length
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
			if player_input == "/save"
				game.save
			elsif player_input == "/load"
				game.load
			else
				game.input(player_input)
			end
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