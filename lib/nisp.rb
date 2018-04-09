# Nisp
module Nisp
  class SandboxEmptyError < StandardError
  end

  class FunctionUndefinedError < StandardError
  end

  class MacroFn < Proc
  end

  # Run nisp
  # @param ctx [Hash] the context to run
  # @return [Object]
  def self.run(ctx)
    sandbox = ctx[:sandbox]
    raise SandboxEmptyError, 'sandbox is missing' if sandbox.nil?

    ast = ctx[:ast]

    if ast.is_a? Array
      return if ast.size.zero?

      action = arg(ctx, 0)

      return apply(action, ctx) if action.is_a? Proc

      unless sandbox.key? action
        raise FunctionUndefinedError, "function '#{action}' is undefined"
      end

      fun = sandbox[action]
      fun.is_a?(Proc) ? apply(fun, ctx) : fun
    else
      ast
    end
  end

  # Expand an argument
  # @param ctx [Hash]
  # @param indes [Integer] index of the arg in the ast array
  # @return [Object]
  def self.arg(ctx, index)
    run(
      ast: ctx[:ast][index],
      sandbox: ctx[:sandbox],
      env: ctx[:env],

      # private
      parent: ctx,
      index: index
    )
  end

  def self.apply(fun, ctx)
    return fun.call(ctx) if fun.is_a? MacroFn

    args = []
    len = ctx[:ast].size
    i = 1
    while i < len
      args[i - 1] = arg(ctx, i)
      i += 1
    end

    fun.call(*args)
  end
end
