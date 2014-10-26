--
-- Author: Black Lotus
-- Date: 2014-09-23 15:26:41
--

--[[
检测圆和未旋转的矩形之间的碰撞 , 还没有测试
参考:http://lazyfoo.net/SDL_tutorials/lesson19/index.php  

~~~ lua  
local intersects = circleIntersectRect(cc.p(10, 10), 50, cc.rect(20, 20, 100, 100))  
~~~  

param: circle_pt 圆心  
param: radius 半径  
param: rect 矩形 {x=0,y=0,width=100,height=100}  
@see   
]]
function circleIntersectRect(circle_pt, radius, rect)  
	local cx = nil  
	local cy = nil  
	-- Find the point on the collision box closest to the center of the circle  
	if circle_pt.x < rect.x then  
	    cx = rect.x  
	elseif circle_pt.x > rect.x + rect.width then  
	    cx = rect.x + rect.width  
	else  
	    cx = circle_pt.x  
	end  

	if circle_pt.y < rect.y then  
	    cy = rect.y  
	elseif circle_pt.y > rect.y + rect.height then  
	    cy = rect.y + rect.height  
	else  
	    cy = circle_pt.y  
	end

	if cc.pGetDistance(circle_pt, cc.p(cx, cy)) < radius then  
	    return true  
	end

	return false  
end

--[[
检测圆之间的碰撞  
~~~ lua  
local intersects = circleIntersects(cc.p(10, 10), 10, cc.p(20,20), 20)  
~~~  
@param: circle_pt_a 圆A中心  
@param: radius_a 圆A半径  
@param: circle_pt_b 圆B中心  
@param: radius_b 圆B半径  

@return 是否碰撞  
@see   
]]  
function circleIntersects(circle_pt_a, radius_a, circle_pt_b, radius_b)  
	-- If the distance between the centers of the circles is less than the sum of their radius  
	if cc.pGetDistance(circle_pt_a, circle_pt_b) < (radius_a + radius_b) then  
	    return true  
	end  
	return false  
end  