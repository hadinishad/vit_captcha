require "vit_captcha/version"
require "Rmagick"
include Magick

class Captcha

  def initialize(file_location)
    @img = ImageList.new(file_location).crop(20,3,87,22).threshold(100).write("test.png")
    @matrix = get_matrix(@img)
    @row = @matrix.size
    @col = @matrix[0].size
    @order = Hash.new()
  end

  def get_matrix(img)
    matrix = Array.new
    temp_arr = Array.new
    col_count = 0
    img.each_pixel do |pixel, col, row|
      val = "0"
      val = "1" if pixel.green == 0
      if col_count > col
        matrix.push(temp_arr)
        col_count = 0
        temp_arr = Array.new
      end
      temp_arr.push(val)
      col_count+=1
    end

    return matrix
  end

  def check_match(letter ,mask, col, row)
    @matrix.each_with_index do |matrix_row, x_off|
      matrix_row.each_with_index do |matrix_ele, y_off|
        next if x_off+col>@row || y_off+row>@col
        flag = 0
        mask.each_with_index do |row, x|
          row.each_with_index do |element, y|
            if element == "1" && @matrix[x+x_off][y+y_off] != "1"
              flag = 1
              break
            end
          end
          break if flag == 1
        end
        @order[y_off]=letter if flag == 0
      end
    end
  end

  def answer
    answer = ""
    @order.sort.each do |letter|
      answer += letter[1].to_s
    end
    answer.delete! '_'
  end

  def get_captcha
    keys = { _0: [["0", "0", "0", "1", "1", "1", "1", "0", "0", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "1", "1", "1", "0", "0", "0", "1", "1", "0"], ["1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "0", "0", "0", "1", "1", "0", "1", "1"], ["1", "1", "0", "0", "1", "1", "0", "0", "1", "1"], ["1", "1", "0", "1", "1", "0", "0", "0", "1", "1"], ["1", "1", "1", "1", "0", "0", "0", "0", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1"], ["0", "1", "1", "0", "0", "0", "1", "1", "1", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "0", "0", "1", "1", "1", "1", "0", "0", "0"] ], _1: [ ["0", "0", "0", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1"] ], _2: [ ["0", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["1", "1", "0", "0", "0", "1", "1", "1", "1", "0"], ["1", "0", "0", "0", "0", "0", "1", "1", "1", "0"], ["0", "0", "0", "0", "0", "0", "1", "1", "1", "0"], ["0", "0", "0", "0", "0", "0", "1", "1", "1", "0"], ["0", "0", "0", "0", "0", "1", "1", "1", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "1", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "1", "1", "1", "1", "0", "0", "0", "0"], ["0", "1", "1", "1", "1", "0", "0", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1"] ], _3: [ ["0", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["0", "0", "0", "0", "0", "0", "0", "1", "1", "1", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "0", "0", "0", "0", "0", "0", "1", "1", "1", "1"], ["0", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "0", "0", "0"] ], _4: [ ["0", "0", "0", "0", "0", "0", "1", "1", "1", "1", "0", "0"], ["0", "0", "0", "0", "0", "1", "1", "1", "1", "1", "0", "0"], ["0", "0", "0", "0", "0", "1", "1", "1", "1", "1", "0", "0"], ["0", "0", "0", "0", "1", "1", "0", "1", "1", "1", "0", "0"], ["0", "0", "0", "1", "1", "1", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0", "1", "1", "1", "0", "0"], ["0", "1", "1", "1", "0", "0", "0", "1", "1", "1", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["0", "0", "0", "0", "0", "0", "0", "1", "1", "1", "0", "0"], ["0", "0", "0", "0", "0", "0", "0", "1", "1", "1", "0", "0"], ["0", "0", "0", "0", "0", "0", "0", "1", "1", "1", "0", "0"] ], _5: [ ["0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["0", "1", "1", "1", "0", "0", "0", "0", "0", "0", "0"], ["0", "1", "1", "1", "0", "0", "0", "0", "0", "0", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "0", "0", "0", "0", "0", "0", "1", "1", "1", "1"], ["0", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["0", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "0", "0", "0"] ], _6: [ ["0", "0", "0", "0", "1", "1", "1", "1", "1", "1", "0"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "1", "1", "1", "1", "0", "0", "0", "0", "0", "0"], ["0", "1", "1", "1", "0", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "1", "1", "1", "1", "1", "0", "0"], ["1", "1", "1", "0", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["0", "1", "1", "1", "0", "0", "0", "1", "1", "1", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "0", "0", "0"] ], _7: [ ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["0", "0", "0", "0", "0", "0", "0", "1", "1", "1", "1"], ["0", "0", "0", "0", "0", "0", "0", "1", "1", "1", "0"], ["0", "0", "0", "0", "0", "0", "1", "1", "1", "1", "0"], ["0", "0", "0", "0", "0", "0", "1", "1", "1", "0", "0"], ["0", "0", "0", "0", "0", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "0", "0", "0", "0", "0"], ["0", "0", "1", "1", "1", "0", "0", "0", "0", "0", "0"], ["0", "0", "1", "1", "1", "0", "0", "0", "0", "0", "0"] ], _8: [ ["0", "0", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "1", "0", "0", "0", "1", "1", "1", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "1", "1", "1", "0", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "1", "0", "0", "0", "1", "1", "1", "1"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "0", "1", "1", "1", "1", "1", "1", "0", "0", "0"] ], _9: [ ["0", "0", "0", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "1", "1", "1", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "1", "0", "0", "0", "0", "1", "1", "1"], ["0", "1", "1", "1", "1", "1", "1", "0", "1", "1", "1"], ["0", "0", "1", "1", "1", "1", "1", "0", "1", "1", "1"], ["0", "0", "0", "0", "0", "0", "0", "1", "1", "1", "0"], ["0", "0", "0", "0", "0", "0", "1", "1", "1", "1", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "1", "1", "1", "1", "1", "1", "0", "0", "0", "0"] ], A: [ ["0", "0", "0", "0", "1", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "1", "1", "1", "0", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0", "1", "1", "1", "0", "0"], ["0", "1", "1", "1", "1", "0", "0", "1", "1", "1", "1", "0"], ["0", "1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "0", "0", "0", "0", "0", "0", "0", "0", "1", "1"] ], B: [ ["1", "1", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"] ], C: [ ["0", "0", "0", "0", "1", "1", "1", "1", "1", "1", "0"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["0", "1", "1", "1", "1", "0", "0", "0", "0", "1", "1"], ["0", "1", "1", "1", "0", "0", "0", "0", "0", "0", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "0"], ["0", "1", "1", "1", "0", "0", "0", "0", "0", "0", "1"], ["0", "1", "1", "1", "1", "0", "0", "0", "0", "1", "1"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["0", "0", "0", "0", "1", "1", "1", "1", "1", "1", "0"] ], D: [ ["1", "1", "1", "1", "1", "1", "1", "1", "0", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "0", "0", "0", "0"] ], E: [ ["1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1"] ], F: [ ["1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"] ], G: [ ["0", "0", "0", "0", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["0", "1", "1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["0", "1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "0", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["0", "1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["0", "1", "1", "1", "1", "1", "0", "0", "0", "0", "1", "1", "1"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["0", "0", "0", "0", "1", "1", "1", "1", "1", "1", "1", "0", "0"] ], H: [ ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"] ], I: [ ["1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1"], ["0", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0"], ["1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1"] ], J: [ ["0", "0", "1", "1", "1", "1", "1", "1"], ["0", "0", "1", "1", "1", "1", "1", "1"], ["0", "0", "0", "0", "0", "1", "1", "1"], ["0", "0", "0", "0", "0", "1", "1", "1"], ["0", "0", "0", "0", "0", "1", "1", "1"], ["0", "0", "0", "0", "0", "1", "1", "1"], ["0", "0", "0", "0", "0", "1", "1", "1"], ["0", "0", "0", "0", "0", "1", "1", "1"], ["0", "0", "0", "0", "0", "1", "1", "1"], ["0", "0", "0", "0", "0", "1", "1", "1"], ["0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "1", "1", "1", "0", "0"] ], K: [ ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "1", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "1", "1", "1", "1", "0", "0"], ["1", "1", "1", "0", "0", "1", "1", "1", "0", "0", "0"], ["1", "1", "1", "0", "1", "1", "1", "0", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "0", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["1", "1", "1", "0", "0", "1", "1", "1", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "1", "1", "1", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"] ], L: [ ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1"] ], M: [ ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "0", "0", "0", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "0", "0", "0", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "0", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "0", "1", "1", "0", "1", "1", "0", "1", "1", "1"], ["1", "1", "1", "0", "1", "1", "1", "1", "1", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "1", "1", "1", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "1", "1", "1", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"] ], N: [ ["1", "1", "1", "1", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "1", "1", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "1", "1", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "0", "0", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "1", "1", "1", "0", "1", "1", "1"], ["1", "1", "1", "0", "1", "1", "1", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "1", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "1", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"] ], O: [ ["0", "0", "0", "0", "1", "1", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "1", "1", "1", "1", "0", "0", "0", "1", "1", "1", "1", "0"], ["0", "1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["0", "1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1", "0"], ["0", "1", "1", "1", "1", "0", "0", "0", "1", "1", "1", "1", "0"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "1", "1", "0", "0", "0", "0"] ], P: [ ["1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0"] ], Q: [ ["0", "0", "0", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["0", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0", "1", "1"], ["1", "1", "0", "0", "0", "0", "0", "0", "0", "0", "1", "1"], ["1", "1", "0", "0", "0", "0", "0", "0", "0", "0", "1", "1"], ["1", "1", "0", "0", "0", "0", "0", "1", "0", "0", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "0", "1", "1"], ["0", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1", "0"], ["0", "1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "1", "0", "1", "0"] ], R: [ ["1", "1", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "1", "1", "1", "1", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["1", "1", "1", "0", "0", "1", "1", "1", "1", "0", "0"], ["1", "1", "1", "0", "0", "0", "1", "1", "1", "0", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"] ], S: [ ["0", "0", "0", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["1", "1", "1", "1", "0", "0", "0", "0", "1", "1", "0"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "0"], ["1", "1", "1", "1", "0", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "1", "1", "1"], ["0", "0", "0", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "0", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "1", "1", "1", "1", "1", "1", "1", "0", "0", "0"] ], T: [ ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"] ], U: [ ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "1", "0", "0", "0", "1", "1", "1", "1"], ["0", "1", "1", "1", "1", "1", "1", "1", "1", "1", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "0", "0", "0"] ], V: [ ["1", "1", "0", "0", "0", "0", "0", "0", "0", "0", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1", "1"], ["0", "1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["0", "1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0"], ["0", "0", "1", "1", "1", "0", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0", "1", "1", "1", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "1", "0", "0", "0", "0"] ], W: [ ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "1", "1", "1", "1", "1", "0", "0", "0", "1", "1", "1"], ["0", "1", "1", "1", "0", "0", "1", "1", "0", "1", "1", "0", "0", "1", "1", "1", "0"], ["0", "1", "1", "1", "0", "0", "1", "1", "0", "1", "1", "0", "0", "1", "1", "1", "0"], ["0", "1", "1", "1", "0", "1", "1", "1", "0", "1", "1", "1", "0", "1", "1", "1", "0"], ["0", "1", "1", "1", "0", "1", "1", "1", "0", "1", "1", "1", "0", "1", "1", "1", "0"], ["0", "1", "1", "1", "0", "1", "1", "0", "0", "0", "1", "1", "0", "1", "1", "1", "0"], ["0", "1", "1", "1", "0", "1", "1", "0", "0", "0", "1", "1", "0", "1", "1", "1", "0"], ["0", "0", "1", "1", "1", "1", "1", "0", "0", "0", "1", "1", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "1", "1", "0", "0", "0", "1", "1", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1", "1", "0", "0"] ], X: [ ["1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1"], ["0", "1", "1", "1", "1", "0", "0", "1", "1", "1", "1", "0"], ["0", "0", "1", "1", "1", "0", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "0", "0", "1", "1", "1", "0", "0"], ["0", "1", "1", "1", "1", "0", "0", "1", "1", "1", "1", "0"], ["1", "1", "1", "1", "0", "0", "0", "0", "1", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "0", "1", "1", "1"] ], Y: [ ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["1", "1", "1", "0", "0", "0", "0", "0", "1", "1", "1"], ["0", "1", "1", "1", "0", "0", "0", "1", "1", "1", "0"], ["0", "1", "1", "1", "1", "0", "1", "1", "1", "1", "0"], ["0", "0", "1", "1", "1", "0", "1", "1", "1", "0", "0"], ["0", "0", "1", "1", "1", "1", "1", "1", "1", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0", "0"] ], Z: [ ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["0", "0", "0", "0", "0", "0", "1", "1", "1", "1"], ["0", "0", "0", "0", "0", "1", "1", "1", "1", "0"], ["0", "0", "0", "0", "0", "1", "1", "1", "0", "0"], ["0", "0", "0", "0", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "1", "0", "0", "0"], ["0", "0", "0", "1", "1", "1", "0", "0", "0", "0"], ["0", "0", "1", "1", "1", "0", "0", "0", "0", "0"], ["0", "1", "1", "1", "1", "0", "0", "0", "0", "0"], ["1", "1", "1", "1", "0", "0", "0", "0", "0", "0"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1"], ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1"] ] }
    count = 0
    keys.each_pair do |letter, mask|

      break if count>=6
      mask_row = mask.size
      mask_col = mask[0].size
      check_match(letter, mask, mask_col, mask_row)
      count = @order.size

    end
    return answer
  end
end