

class ParamAF:
    def __init__(self):
        self.func_type = None
        self.pre_delay = None
        self.compute_delay = None
        self.axis_delay = None
        self.add_delay = None
        self.bit_length = None
        self.mini_length1 = None
        self.range_num1 = None
        self.mini_length2 = None
        self.range_num2 = None
        self.k_bit_length = None
        self.b_bit_length = None

    def set_func_type(self, func_type):
        self.func_type = func_type

    def set_pre_delay(self, pre_delay):
        self.pre_delay = pre_delay

    def set_compute_delay(self, compute_delay):
        self.compute_delay = compute_delay

    def set_axis_delay(self, axis_delay):
        self.axis_delay = axis_delay

    def set_add_delay(self, add_delay):
        self.add_delay = add_delay

    def set_bit_length(self, bit_length):
        self.bit_length = bit_length

    def set_mini_length1(self, mini_length1):
        self.mini_length1 = mini_length1

    def set_range_num1(self, range_num1):
        self.range_num1 = range_num1

    def set_mini_length2(self, mini_length2):
        self.mini_length2 = mini_length2

    def set_range_num2(self, range_num2):
        self.range_num2 = range_num2

    def set_k_bit_length(self, k_bit_length):
        self.k_bit_length = k_bit_length

    def set_b_bit_length(self, b_bit_length):
        self.b_bit_length = b_bit_length
