import rjit
# __fix__ specifies the global variables that won't change
__fix__ = ['f', 'g']

@rjit.aware
class Point:
  x: int
  y: int
  def __init__(self, x, y):
      self.x = x
      self.y = y

@rjit.aware
def add_x_(p, x):
   p.x += x
