import React from 'react';
import { Card, CardContent } from './ui/card';
import { Button } from './ui/button';
import { ThumbsUp, ThumbsDown, Star, Play } from 'lucide-react';
import { Badge } from './ui/badge';

interface Movie {
  id: number;
  title: string;
  poster: string;
  year: number;
  genre: string[];
  rating: number;
  votes: {
    upvotes: number;
    downvotes: number;
  };
  description: string;
}

interface MovieCardProps {
  movie: Movie;
  onMovieClick: (movie: Movie) => void;
  onUpvote: (movieId: number) => void;
  onDownvote: (movieId: number) => void;
}

const MovieCard: React.FC<MovieCardProps> = ({ 
  movie, 
  onMovieClick, 
  onUpvote, 
  onDownvote 
}) => {
  return (
    <Card className="group relative overflow-hidden bg-gradient-to-br from-slate-900 to-slate-800 border-slate-700 hover:border-slate-600 transition-all duration-300 hover:scale-105 hover:shadow-2xl">
      <div className="relative aspect-[2/3] overflow-hidden">
        <img 
          src={movie.poster} 
          alt={movie.title}
          className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-110"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
        
        {/* Hover overlay with play button */}
        <div className="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300">
          <Button 
            size="lg" 
            className="bg-red-600 hover:bg-red-700 text-white rounded-full"
            onClick={() => onMovieClick(movie)}
          >
            <Play className="h-6 w-6 mr-2" />
            View Details
          </Button>
        </div>

        {/* Rating badge */}
        <div className="absolute top-2 right-2">
          <Badge className="bg-yellow-500 text-black font-bold">
            <Star className="h-3 w-3 mr-1" />
            {movie.rating}
          </Badge>
        </div>
      </div>

      <CardContent className="p-4">
        <h3 className="text-white font-bold text-lg mb-1 truncate">
          {movie.title}
        </h3>
        <p className="text-slate-400 text-sm mb-2">{movie.year}</p>
        
        {/* Genres */}
        <div className="flex flex-wrap gap-1 mb-3">
          {movie.genre.slice(0, 2).map((genre) => (
            <Badge key={genre} variant="secondary" className="text-xs">
              {genre}
            </Badge>
          ))}
        </div>

        {/* Description */}
        <p className="text-slate-300 text-sm mb-4 line-clamp-2">
          {movie.description}
        </p>

        {/* Voting buttons */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Button
              size="sm"
              variant="outline"
              className="border-green-500 text-green-500 hover:bg-green-500 hover:text-white"
              onClick={(e) => {
                e.stopPropagation();
                onUpvote(movie.id);
              }}
            >
              <ThumbsUp className="h-4 w-4 mr-1" />
              {movie.votes.upvotes}
            </Button>
            <Button
              size="sm"
              variant="outline"
              className="border-red-500 text-red-500 hover:bg-red-500 hover:text-white"
              onClick={(e) => {
                e.stopPropagation();
                onDownvote(movie.id);
              }}
            >
              <ThumbsDown className="h-4 w-4 mr-1" />
              {movie.votes.downvotes}
            </Button>
          </div>
        </div>
      </CardContent>
    </Card>
  );
};

export default MovieCard;
