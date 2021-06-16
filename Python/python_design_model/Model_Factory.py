# -*- coding: utf-8 -*-
'''
simple Factory Method
'''
 
 
class Shape(object):
    def draw(self):
        raise NotImplementedError
 
class Circle(Shape):
    def draw(self):
        print('draw circle')
 
class Rectangle(Shape):
    def draw(self):
        print('draw Rectangle')
 
class ShapeFactory(object):
    '''
    工厂模式：暴露给用户去调用的，
    用户可通过该类进行选择Shape的子类进行实例化
    '''
    def create(self, shape):
        if shape == 'Circle':
            return Circle()
        elif shape == 'Rectangle':
            return Rectangle()
        else:
            return None


fac = ShapeFactory() #实例化工厂类
obj = fac.create('Circle') #实例化Shape的Circle子类
obj.draw()