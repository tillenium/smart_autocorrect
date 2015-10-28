class Dictionary < ActiveRecord::Base

  def self.is_word_present? word
    return Dictionary.where(word: word).first
  end

  def increase_word_count count
    self.count += count
    self.save
  end

  def self.add_word word,meaning
    word.strip!
    meaning.strip!
    dict = Dictionary.where(word: word).first
    if !dict.present?
      dict = Dictionary.new({word: word,meaning: meaning, count: 1})
      dict.save!
    end
    return dict
  end

  def self.probable_words(word)
    words = known_probable(word)
  end
  
  private

  #words that are upto one edit distance from the word
  def self.edit_distance_one(word)
    words = []
    #delete
    (0..word.size-1).each do |index|
      string = String.new word
      string.slice!(index)
      words.push(string)
    end

    #insert
    (0..word.size).each do |index|
      ('a'..'z').each do |letter|
        string = String.new word
        string.insert(index,letter)
        words.push(string)
      end
    end

    #replace
    (0..word.size-1).each do |index|
      ('a'..'z').each do |letter|
        string = String.new word
        string[index] = letter
        words.push(string)
      end
    end
    words
  end

  def self.edit_distance_two(input_word)
    ed1 =  edit_distance_one input_word
    ed2 = []
    ed1.select {|word| ed2 += edit_distance_one(word)}
    return (ed2+ed1).uniq
  end

  def self.known_probable(word)
    words = edit_distance_two(word)
    #words.delete_if {|word| !is_word_present? (word)}
    return  Dictionary.where(word: words).order('count desc').map(&:word)
  end
end
