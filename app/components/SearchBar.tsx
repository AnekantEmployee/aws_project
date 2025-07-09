import React, { useState } from 'react';
import { Input } from './ui/input';
import { Button } from './ui/button';
import { Search, Filter, X } from 'lucide-react';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from './ui/select';

interface SearchBarProps {
  onSearch: (query: string, filters?: SearchFilters) => void;
  onClear: () => void;
}

interface SearchFilters {
  genre?: string;
  year?: string;
  rating?: string;
}

const SearchBar: React.FC<SearchBarProps> = ({ onSearch, onClear }) => {
  const [query, setQuery] = useState('');
  const [showFilters, setShowFilters] = useState(false);
  const [filters, setFilters] = useState<SearchFilters>({});

  const handleSearch = () => {
    onSearch(query, filters);
  };

  const handleClear = () => {
    setQuery('');
    setFilters({});
    onClear();
  };

  const genres = [
    'Action', 'Adventure', 'Animation', 'Comedy', 'Crime', 'Documentary',
    'Drama', 'Family', 'Fantasy', 'Horror', 'Music', 'Mystery', 'Romance',
    'Science Fiction', 'Thriller', 'War', 'Western'
  ];

  const years = Array.from({ length: 30 }, (_, i) => (2024 - i).toString());

  return (
    <div className="w-full max-w-4xl mx-auto space-y-4">
      {/* Main search bar */}
      <div className="relative flex items-center gap-2">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-slate-400 h-5 w-5" />
          <Input
            placeholder="Search for movies, actors, directors..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSearch()}
            className="pl-10 pr-4 py-3 text-lg bg-slate-800/50 border-slate-600 text-white placeholder-slate-400 focus:border-red-500 focus:ring-red-500/20"
          />
        </div>
        
        <Button 
          onClick={handleSearch}
          className="bg-red-600 hover:bg-red-700 text-white px-6 py-3"
          size="lg"
        >
          <Search className="h-5 w-5 mr-2" />
          Search
        </Button>
        
        <Button
          variant="outline"
          onClick={() => setShowFilters(!showFilters)}
          className="border-slate-600 text-slate-300 hover:bg-slate-700 px-4 py-3"
          size="lg"
        >
          <Filter className="h-5 w-5" />
        </Button>

        {(query || Object.values(filters).some(Boolean)) && (
          <Button
            variant="ghost"
            onClick={handleClear}
            className="text-slate-400 hover:text-white px-4 py-3"
            size="lg"
          >
            <X className="h-5 w-5" />
          </Button>
        )}
      </div>

      {/* Filters */}
      {showFilters && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 p-4 bg-slate-800/30 rounded-lg border border-slate-700">
          <div>
            <label className="block text-sm font-medium text-slate-300 mb-2">
              Genre
            </label>
            <Select 
              value={filters.genre || ''} 
              onValueChange={(value) => setFilters({...filters, genre: value})}
            >
              <SelectTrigger className="bg-slate-700 border-slate-600 text-white">
                <SelectValue placeholder="Any genre" />
              </SelectTrigger>
              <SelectContent className="bg-slate-800 border-slate-600">
                <SelectItem value="">Any genre</SelectItem>
                {genres.map((genre) => (
                  <SelectItem key={genre} value={genre.toLowerCase()}>
                    {genre}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div>
            <label className="block text-sm font-medium text-slate-300 mb-2">
              Year
            </label>
            <Select 
              value={filters.year || ''} 
              onValueChange={(value) => setFilters({...filters, year: value})}
            >
              <SelectTrigger className="bg-slate-700 border-slate-600 text-white">
                <SelectValue placeholder="Any year" />
              </SelectTrigger>
              <SelectContent className="bg-slate-800 border-slate-600">
                <SelectItem value="">Any year</SelectItem>
                {years.map((year) => (
                  <SelectItem key={year} value={year}>
                    {year}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div>
            <label className="block text-sm font-medium text-slate-300 mb-2">
              Rating
            </label>
            <Select 
              value={filters.rating || ''} 
              onValueChange={(value) => setFilters({...filters, rating: value})}
            >
              <SelectTrigger className="bg-slate-700 border-slate-600 text-white">
                <SelectValue placeholder="Any rating" />
              </SelectTrigger>
              <SelectContent className="bg-slate-800 border-slate-600">
                <SelectItem value="">Any rating</SelectItem>
                <SelectItem value="9+">9+ Excellent</SelectItem>
                <SelectItem value="8+">8+ Very Good</SelectItem>
                <SelectItem value="7+">7+ Good</SelectItem>
                <SelectItem value="6+">6+ Above Average</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
      )}
    </div>
  );
};

export default SearchBar;
