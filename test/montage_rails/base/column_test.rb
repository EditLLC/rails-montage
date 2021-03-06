require 'test_helper'
require 'montage_rails/base/column'

class MontageRails::Base::ColumnTest < Minitest::Test
  context "#value_valid?" do
    should "return false if the value is required and nil is passed in" do
      @column = MontageRails::Base::Column.new("foo", "integer", true)
      assert !@column.value_valid?(nil)
    end

    should "return true if the value is required and a proper value is passed in" do
      @column = MontageRails::Base::Column.new("foo", "integer", true)
      assert @column.value_valid?(1)
    end

    should "return true if the value is not required and nil is passed in" do
      @column = MontageRails::Base::Column.new("foo", "integer", false)
      assert @column.value_valid?(nil)
    end
  end

  context "#coerce" do
    should "not perform a coercion if the value is already in the right format" do
      column = MontageRails::Base::Column.new("foo", "numeric")
      Virtus::Attribute.expects(:build).never
      assert_equal 4.0, column.coerce(4.0)
    end

    should "coerce a float to a float" do
      column = MontageRails::Base::Column.new("foo", "float")
      assert_equal 4.0, column.coerce("4.0")
    end

    should "coerce an integer to an integer" do
      column = MontageRails::Base::Column.new("foo", "float")
      assert_equal 4, column.coerce("4")
    end

    should "coerce a date time to a date time" do
      column = MontageRails::Base::Column.new("foo", "datetime")
      assert_equal DateTime.new(2015, 4, 20), column.coerce("2015-04-20")
    end

    should "coerce an integer to an integer when the type is numeric" do
      column = MontageRails::Base::Column.new("foo", "numeric")
      assert_equal 4, column.coerce("4")
    end

    should "coerce a float to a float when the type is numeric" do
      column = MontageRails::Base::Column.new("foo", "numeric")
      assert_equal 4.0, column.coerce("4.0")
    end

    should "coerce a string to a string" do
      column = MontageRails::Base::Column.new("foo", "float")
      assert_equal "foo", column.coerce("foo")
    end

    should "coerce a float to a float when the float is not a string" do
      column = MontageRails::Base::Column.new("foo", "numeric")
      assert_equal 60.0, column.coerce(60.000000)
    end

    should "coerce a 'true' string to a boolean" do
      column = MontageRails::Base::Column.new("foo", "boolean")
      assert column.coerce('true') 
    end

    should "coerce a 'false' string to a boolean" do
      column = MontageRails::Base::Column.new("foo", "boolean")
      puts column.coerce('false')
      refute column.coerce('false') 
    end

    should "handle a TrueClass" do
      column = MontageRails::Base::Column.new("foo", "boolean")
      assert column.coerce(true)
    end

    should "handle a FalseClass" do
      column = MontageRails::Base::Column.new("foo", "boolean")
      refute column.coerce(false)
    end
  end

  context "is_i?" do
    setup do
      @column = MontageRails::Base::Column.new("foo", "numeric")
    end

    should "properly handle Fixnum and Floats" do
      assert @column.is_i?(60)
      refute @column.is_i?(60.45)
    end
  end

  context "is_f?" do
    setup do
      @column = MontageRails::Base::Column.new("foo", "numeric")
    end

    should "properly handle Fixnum and floats" do
      assert @column.is_f?(60.45)
      refute @column.is_f?(60)
    end
  end
end
