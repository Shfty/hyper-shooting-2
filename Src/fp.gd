extends Node

func compose(funcs: Array, val):
	for i in range(0, funcs.size()):
		var f = funcs[funcs.size() - 1 - i]
		val = f.call(val)
	return val

func pipe(val, funcs: Array):
	for i in range(0, funcs.size()):
		var f = funcs[i]
		val = f.call(val)
	return val

func curry(inst: Object, func_name: String, args: Array):
	match args.size():
		0:
			return Curried.new(inst, func_name)
		1:
			return Curried2.new(inst, func_name, args[0])
		2:
			return Curried3.new(inst, func_name, args[0], args[1])
		3:
			return Curried4.new(inst, func_name, args[0], args[1], args[2])
		_:
			return null

func add(a, b):
	return a + b
	
func sub(a, b):
	return a - b
	
func mul(a, b):
	return a * b
	
func div(a, b):
	return a / b

class Curried:
	var func_ref: FuncRef = null
	
	func _init(inst, func_name):
		self.func_ref = funcref(inst, func_name)
	
	func call(arg1):
		return self.func_ref.call_func(arg1)

class Curried2 extends Curried:
	var arg1 = null
	
	func _init(inst, func_name, arg1).(inst, func_name):
		self.arg1 = arg1
	
	func call(arg2):
		return self.func_ref.call_func(self.arg1, arg2)

class Curried3 extends Curried2:
	var arg2 = null
	
	func _init(inst, func_name, arg1, arg2).(inst, func_name, arg1):
		self.arg2 = arg2
	
	func call(arg3):
		return self.func_ref.call_func(self.arg1, arg2, arg3)

class Curried4 extends Curried3:
	var arg3 = null
	
	func _init(inst, func_name, arg1, arg2, arg3).(inst, func_name, arg1, arg2):
		self.arg3 = arg3
	
	func call(arg4):
		return self.func_ref.call_func(self.arg1, arg2, arg3, arg4)
