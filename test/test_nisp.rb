require 'minitest/autorun'
require 'nisp'

class NispTest < MiniTest::Test
  def test_basic
    out = Nisp.run(
      ast: ['+', 1, 2],
      sandbox: {
        '+' => ->(a, b) { a + b }
      }
    )

    assert_equal 3, out
  end

  def test_nested
    out = Nisp.run(
      ast: ['+', 1, ['+', 2, 3]],
      sandbox: {
        '+' => ->(a, b) { a + b }
      }
    )

    assert_equal 6, out
  end

  def test_empty_sandbox
    assert_raises Nisp::SandboxEmptyError do
      Nisp.run({})
    end
  end

  def test_undefined_function
    assert_raises Nisp::FunctionUndefinedError do
      Nisp.run(
        ast: ['+'],
        sandbox: {}
      )
    end
  end

  def test_macro
    out = Nisp.run(
      ast: ['+', 1, 2],
      env: 3,
      sandbox: {
        '+' => Nisp::MacroFn.new { |ctx| ctx[:env] + Nisp.arg(ctx, 1) + Nisp.arg(ctx, 2) }
      }
    )

    assert_equal 6, out
  end

  def test_env
    out = Nisp.run(
      ast: ['+', 1, 2],
      env: 3,
      sandbox: {
        '+' => ->(a, b) { a + b + self }
      }
    )

    assert_equal 6, out
  end
end
