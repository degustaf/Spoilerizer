# Defines

MKDIR=mkdir -p

PATHS = 			src
PATHI =				include
PATHB = 			build
PATHD =				depend
SRCS =				$(wildcard $(PATHS)/*.cpp)
LIBRARY =			libaoc.a
CXX = 				g++
LINK = 				$(CXX)
CXX_STD =			c++17
DEF =				-g
CXXFLAGS =			-I$(PATHI) -Wall -Wextra -Werror -pedantic $(ARCH) -std=$(CXX_STD) -O3 -D_POSIX_C_SOURCE=200809L $(DEF)

LDFLAGS =			$(ARCH) $(DEF)
LDLIBS =			-pthread

COMPILE =			$(CXX) $(CXXFLAGS) -MT $@ -MP -MMD -MF $(PATHD)/$*.Td
OBJS =				$(addprefix $(PATHB)/, $(notdir $(SRCS:.cpp=.o)))
POSTCOMPILE =		@mv -f $(PATHD)/$*.Td $(PATHD)/$*.d && touch $@

.PHONY: all clean unittest

.PRECIOUS: $(PATHD)/%.d
.PRECIOUS: $(PATHB)/%.o
.PRECIOUS: $(PATHB)/%.a


# Rules

all: spoilerizer


./$(PATHB):
	$(MKDIR) $@

$(PATHD):
	$(MKDIR) $@


spoilerizer: $(PATHB)/spoilerizer | $(PATHB)
	ln -sf $^ $@

$(PATHB)/%: $(PATHB)/%.o | $(PATHB)
	$(LINK) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(PATHB)/%.o: $(PATHS)/%.cpp | $(PATHB) $(PATHD)
	$(COMPILE) -c $< -o $@
	$(POSTCOMPILE)

clean:
	$(RM) $(PATHD)/*.d
	$(RM) $(PATHD)/*.Td
	$(RM) $(PATHB)/*
	$(RM) ./spoilerizer

include $(wildcard $(PATHD)/*.d)
