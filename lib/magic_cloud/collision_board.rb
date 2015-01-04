# encoding: utf-8
require_relative './bit_matrix'

module MagicCloud
  class CollisionBoard < BitMatrix
    def initialize(width, height)
      super
      @rects = []
      @intersections_cache = {}
    end
    
    attr_reader :rects, :intersections_cache

    def collides?(shape)
      Debug.stats[:collide_total] += 1
      
      return false if rects.empty? # nothing on board - so, no collisions
      
      rect = shape.rect

      if rects.any?{|r| r.criss_cross?(rect)}
        Debug.stats[:criss_cross] += 1 
        # no point to try drawing criss-crossed words
        # even if they will not collide pixel-per-pixel
        return true 
      end

      # then find which of placed sprites rectangles tag intersects
      intersections = rects.map{|r| r.intersect(rect)}
      
      if intersections.compact.empty?
        Debug.stats[:rect_no] += 1 
        # no need to further check: this tag is not inside any others' rectangle
        return false
      end
      
      # most probable that we are still collide with this word
      prev_idx = intersections_cache[shape.object_id]
      if prev_idx && (prev = intersections[prev_idx])
        if collides_inside?(shape, prev)
          Debug.stats[:px_prev_yes] += 1
          return true
        end
      end
      
      # only then check points inside intersected rectangles
      intersections.each_with_index do |intersection, idx|
        next unless intersection
        next if idx == intersections_cache[shape.object_id] # already checked it
        
        if collides_inside?(shape, intersection)
          Debug.stats[:px_yes] += 1
          intersections_cache[shape.object_id] = idx
          return true
        end
      end
      
      Debug.stats[:px_no] += 1
      return false
    end
    
    def collides_inside?(shape, rect)
      (rect.x0...rect.x1).each do |x|
        (rect.y0...rect.y1).each do |y|
          dx = x - shape.left
          dy = y - shape.top
          return true if shape.sprite.at(dx, dy) && at(x, y)
        end
      end
      return false
    end
    
    def add(shape)
      shape.height.times do |dy|
        shape.width.times do |dx|
          put(shape.left+dx, shape.top+dy) if shape.sprite.at(dx, dy) 
        end
      end
      
      rects << shape.rect
    end
  end
end
