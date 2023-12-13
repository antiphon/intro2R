#
# Course pre-check, "Introduction to R"
#
# Luke, 2024
#
# tuomas.rajala@luke.fi
#
#
# 
## Can you read this?  ----
# 
# If you understand what this R-script, a file with the suffix ".R", is doing,
# and you can figure out, using the hints or otherwise, how to fix the bugs in
# it, you probably do not need to participate in the course. But feel free
# to join anyway, you might learn something new!
#
#
# 
# General tips: 
#
# 1. Open this file in Rstudio.
# 2. Execute code line by line in the console.
#    In Rstudio: Move text cursor to a line in the editor ("Source") and press
#    Ctrl+Enter (Cmd+Enter in Mac).
# 3. "<-" is the assignment operator in R.
# 4. For functions, say "rep", open help documentation by executing "?rep"
#    in the console. 
# 5. Or for help in Rstudio: Move text cursor somewhere on the function name and
#    press the F1 key.
# 6. Vector and arrays are base-1 indexed.
# 7. Indentations and white-spaces do not matter.
# 8. If the prompt ">" turns to "+", a parenthesis is missing.
#    Hit Esc to cancel the current execution.
#
# Let's go. Look for "TODO"s.
#
#
### Task X: Do <what?> and <what?>, then <what?> and finally <what?> ----
#

####  Step 1 ----
# Create some data in vectors
#
# by hand. "c" is for "combine"
var1 <- c(89, 85, 84, 120, 180, 191)

# By random mechanism. Sample some uniform values.
set.seed(1234)
var2 <- c(
          runif(n=3, min= 0, max=1), 
          runif(3, 0, 3)
          )

# By calculation: linear algebra
x3   <- var2 * 50.4 + 20

# Making of
dat <- data.frame(var1, var2, mystery = x3)

# running the name only
dat  
# is in the interactive session the same as the function call
print(dat)

# Make nicer 
dat <-  setNames(dat, c("age", "height", "weight"))

print(dat)

#  ?
cl        <- rep(c("a", "b"), each = 3)
dat$class <- cl 

print(dat)


# Slicing and indexing.
#
# The shape is
dim(dat)

# For quick regular sequence useful in indexing, use "from:to"
1:12

dat[4:5, ]

print(dat[1:2, 2:5]) # TODO: Bug with error!

print(dat[dat$class == "a", "Age"]) # TODO: Bug without error! fix.

# sub-setting the whole table
subdat <- subset(dat, class == "a" & height > 0.5) 

subdat

# Store the data in a file.
write.csv(dat, "~/dataset_v1.csv", row.names = FALSE)


# Read the data into a new object, and continue editing.
dat2    <- read.csv("~/dataset_v1.csv", header = TRUE)
school  <- c("s1", "s2", "s1", 
             "s3", "s1", "s2", )  # TODO: bug!

dat3 <- cbind(dat2, school = school)

print(dat3)
table(dat3$class, dat3$school)

# whoops a mistake. Let's fix.

dat3$school[ dat3$school == "s3" ] <- "s2"

table(dat3$class, dat3$school)


# ok. Copy to another object with more descriptive name.
things <- dat3

#### Step 2: Summarise  ----
boxplot(height ~ class + school, data = things, col = "orange")

with(things,
     plot( height, weight, col = factor(class) ) 
     )

# means  
grp_means <- aggregate(height ~ class + school, mean, things) # TODO: Bug!
# (hint: see order of arguments in docs, or use named arguments, like in the boxplot)
print(grp_means, digits = 2)


# ok ok
ntable <- xtabs(~class + school, things) 
ntable <- addmargins(ntable)
print(ntable)



#### Step 3 ----
result1 <- aov(height ~ class + school, data = things)
result2 <- aov(height ~ class * school, data = things)

# check results
summary(result1)
# or?
summary(result2)
# hmm
anova(result1, result2)

# Comparison
tuk <- TukeyHSD(result1)
print(tuk)

#### Step 4 ----

tukcl  <- tuk[["class"]]
txt    <- paste(colnames(tukcl), round(tukcl, 2), sep = ": ", collapse = ", ")

# 
print_to_file <- FALSE 

# 1-liner, no need for {}'s
if(print_to_file) pdf(file = "boxplot_v1.pdf", width = 5, height = 5)

boxplot(height ~ class,
        data = things, 
        main = txt, 
        col  = "orange",
        xlab = "Treatment", 
        ylab = "Height (cm)"
        )

if(print_to_file) dev.off()

#
# TODO: Make it "print" the boxplot into a pdf-file.
#
####
# Check everything works by executing the whole script in one go by 
#
# > source("pre-course-test.R") 
#
# or use the Source-command or button in Rstudio.
#
#