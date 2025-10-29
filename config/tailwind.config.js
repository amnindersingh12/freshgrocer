const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*.{rb,erb}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        primary: {
          DEFAULT: '#5B6C9D',
          50: '#E8EBF3',
          100: '#D1D7E7',
          200: '#A3AFCF',
          300: '#7587B7',
          400: '#6877AA',
          500: '#5B6C9D',
          600: '#4A5780',
          700: '#384163',
          800: '#262C46',
          900: '#151729',
        },
        secondary: {
          DEFAULT: '#7EB09E',
          50: '#EDF5F2',
          100: '#DBEBE5',
          200: '#B7D7CB',
          300: '#93C3B1',
          400: '#89B9A8',
          500: '#7EB09E',
          600: '#658D7E',
          700: '#4C6A5F',
          800: '#33463F',
          900: '#1A2320',
        },
        accent: {
          DEFAULT: '#D4A574',
          50: '#F9F3ED',
          100: '#F3E7DB',
          200: '#E7CFB7',
          300: '#DBB793',
          400: '#D7AE84',
          500: '#D4A574',
          600: '#AA845D',
          700: '#7F6346',
          800: '#55422F',
          900: '#2A2117',
        },
        background: '#F8FAFC',
        surface: '#FFFFFF',
        text: {
          DEFAULT: '#2D3748',
          light: '#718096',
        },
        muted: '#718096',
        border: '#E2E8F0',
      },
      animation: {
        'fade-up': 'fadeUp 0.6s ease-out',
        'fade-in': 'fadeIn 0.5s ease-out',
        'gentle-pulse': 'gentlePulse 2s ease-in-out infinite',
        'soft-bounce': 'softBounce 0.4s ease-out',
      },
      keyframes: {
        fadeUp: {
          '0%': { opacity: '0', transform: 'translateY(10px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        gentlePulse: {
          '0%, 100%': { opacity: '1' },
          '50%': { opacity: '0.8' },
        },
        softBounce: {
          '0%, 100%': { transform: 'scale(1)' },
          '50%': { transform: 'scale(1.03)' },
        },
      },
      transitionDuration: {
        '400': '400ms',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ],
  safelist: [
    'animate-fade-up',
    'animate-fade-in',
    'animate-gentle-pulse',
    'animate-soft-bounce',
  ],
}
