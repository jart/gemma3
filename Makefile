#-*-mode:makefile-gmake;indent-tabs-mode:t;tab-width:8;coding:utf-8-*-┐
#── vi: set et ft=make ts=8 sw=8 fenc=utf-8 :vi ──────────────────────┘

CXXFLAGS = -O -g -pthread -fexceptions -fmerge-all-constants -fmath-errno
LDFLAGS = -pthread

.PHONY: all
all: gemma

.PHONY: clean
clean:
	rm -rf *.o *.a gemma .aarch64 *.elf *.dbg

################################################################################
# gemma.cpp

gemma:		run.o					\
		gemma.o					\
		blob_store.o				\
		libhwy.a				\
		libvqsort.a				\
		libsentencepiece.a			\
		libhwy.a
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS) -o $@

%.o: %.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -I. -Isentencepiece -Ihighway -c $<

%.o: compression/%.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -I. -Isentencepiece -Ihighway -c $<

gemma.o: gemma.cc ops.h

################################################################################
# life is a highway

libhwy.a:	aligned_allocator.o			\
		nanobenchmark.o				\
		per_target.o				\
		print.o					\
		targets.o				\
		timer.o
	$(AR) rcsD $@ $^

%.o: highway/hwy/%.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -I. -Ihighway -c $<

################################################################################
# vectorized quicksort

libvqsort.a:	vqsort_128a.o				\
		vqsort_128d.o				\
		vqsort_f16a.o				\
		vqsort_f16d.o				\
		vqsort_f32a.o				\
		vqsort_f32d.o				\
		vqsort_f64a.o				\
		vqsort_f64d.o				\
		vqsort_i16a.o				\
		vqsort_i16d.o				\
		vqsort_i32a.o				\
		vqsort_i32d.o				\
		vqsort_i64a.o				\
		vqsort_i64d.o				\
		vqsort_kv128a.o				\
		vqsort_kv128d.o				\
		vqsort_kv64a.o				\
		vqsort_kv64d.o				\
		vqsort_u16a.o				\
		vqsort_u16d.o				\
		vqsort_u32a.o				\
		vqsort_u32d.o				\
		vqsort_u64a.o				\
		vqsort_u64d.o				\
		image.o					\
		vqsort.o
	$(AR) rcsD $@ $^

%.o: highway/hwy/contrib/sort/%.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -I. -Ihighway -c $<

%.o: highway/hwy/contrib/image/%.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -I. -Ihighway -c $<

################################################################################
# absl, protobuf, sentencepiece

libsentencepiece.a:					\
		arena.o					\
		arenastring.o				\
		bytestream.o				\
		coded_stream.o				\
		common.o				\
		extension_set.o				\
		generated_enum_util.o			\
		generated_message_table_driven_lite.o	\
		generated_message_util.o		\
		implicit_weak_message.o			\
		int128.o				\
		io_win32.o				\
		message_lite.o				\
		parse_context.o				\
		repeated_field.o			\
		status.o				\
		statusor.o				\
		stringpiece.o				\
		stringprintf.o				\
		structurally_valid.o			\
		strutil.o				\
		time.o					\
		wire_format_lite.o			\
		zero_copy_stream.o			\
		zero_copy_stream_impl.o			\
		zero_copy_stream_impl_lite.o		\
		sentencepiece.pb.o			\
		sentencepiece_model.pb.o		\
		bpe_model.o				\
		char_model.o				\
		error.o					\
		filesystem.o				\
		model_factory.o				\
		model_interface.o			\
		normalizer.o				\
		sentencepiece_processor.o		\
		unigram_model.o				\
		util.o					\
		word_model.o				\
		flag.o
	$(AR) rcsD $@ $^

%.o: sentencepiece/src/%.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -I. -Isentencepiece -Isentencepiece/third_party/absl -Isentencepiece/third_party/protobuf-lite -Isentencepiece/src/builtin_pb -c $<

%.o: sentencepiece/src/builtin_pb/%.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -Isentencepiece -Isentencepiece/third_party/absl -Isentencepiece/third_party/protobuf-lite -Isentencepiece/src/builtin_pb -c $<

%.o: sentencepiece/third_party/absl/flags/%.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -I. -Isentencepiece -Isentencepiece/third_party/absl -Isentencepiece/third_party/protobuf-lite -c $<

%.o: sentencepiece/third_party/protobuf-lite/%.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -DHAVE_PTHREAD -Isentencepiece/third_party/absl -Isentencepiece/third_party/protobuf-lite -c $<
